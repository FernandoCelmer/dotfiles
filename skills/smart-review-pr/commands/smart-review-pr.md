---
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr list:*), Bash(gh pr edit:*), Bash(gh api:*), Bash(gh repo view:*), Bash(git log:*), Bash(git diff:*), Bash(git blame:*), Bash(git ls-files:*), Bash(jq:*), Bash(python3:*)
description: Use this skill when the user asks to "validar PR", "validate PR", "review PR", "revisar PR", "checar PR", "check PR", mentions a PR number to review/validate, or asks to review a pull request before merging. Performs a comprehensive PR review covering code quality, security, architecture, design patterns, CLAUDE.md compliance and historical context — posts inline comments directly on the PR.
version: 2.0.0
---

# Review PR

Perform a comprehensive, high-signal review of a pull request. Catch real bugs and non-compliance issues. Avoid false positives and nitpicks.

Make a todo list and track progress through all steps.

---

## Step 1 — Check eligibility

Use a Haiku agent to verify:
- PR is open and not a draft
- Has actual code changes worth reviewing
- Has not already been reviewed in this session

If any condition fails, stop and inform the user.

---

## Step 2 — Collect context

Run in parallel:

**2a. Collect CLAUDE.md files** (Haiku agent)
List paths (not contents) of:
- Root `CLAUDE.md` if it exists
- Any `CLAUDE.md` inside directories modified by the PR

**2b. Summarize the PR** (Haiku agent)
Read title, description and diff. Return a concise summary of what changed and why.

**2c. Validate PR structure** (Haiku agent)
Evaluate:
- **Title**: clear, concise, follows conventional commit format if the project uses it
- **Description**: explains *what* changed and *why*, links to issue/ticket if applicable
- **Size**: flag if changes more than ~500 lines across unrelated concerns
- **Tests**: are there tests for new/changed behavior?
- **Labels/assignees**: set appropriately?

---

## Step 3 — Run 5 parallel analysis agents (Sonnet)

**Agent 1 – CLAUDE.md compliance**
Read CLAUDE.md files from step 2a. Check changes comply with all rules. Only flag explicit violations.

**Agent 2 – Bug hunting, code quality & security**
Scan the diff for:

*Correctness & Logic*
- Logic errors, wrong conditions, inverted booleans
- Off-by-one, boundary conditions
- Null/undefined/empty handling
- Async issues: race conditions, missing awaits, deadlocks
- Error handling: silent catches, swallowed exceptions, missing rollbacks

*Security (OWASP Top 10 + extras)*
- Injection: SQL, command, LDAP, XPath, template injection
- Broken authentication: weak tokens, missing expiration, insecure sessions
- Sensitive data exposure: secrets in code, logs, responses or errors
- Broken access control: missing auth checks, IDOR, privilege escalation
- Security misconfiguration: permissive CORS, debug mode on, default credentials
- XSS: unescaped output, unsafe innerHTML, missing CSP
- Insecure deserialization
- SSRF, path traversal, open redirects

*Project Structure & Architecture*
- Business logic in wrong layer (controllers, views)
- Violated separation of concerns
- Circular dependencies
- Hardcoded config that should be in env vars
- Dead code or commented-out blocks

*Design Patterns & Best Practices*
- SOLID violations: SRP, OCP, LSP, ISP, DIP
- God classes, shotgun surgery, feature envy, premature optimization
- DRY / KISS violations
- Missing or misused design patterns (Strategy, Factory, Repository, etc.)
- Law of Demeter violations, magic numbers

*Code Quality*
- Unclear or misleading naming
- Functions too long or with too many parameters
- Deeply nested code
- Missing comments on non-obvious logic
- Algorithmic complexity issues (e.g. O(n²) where O(n) is straightforward)

*Performance*
- N+1 queries, missing pagination
- Unnecessary recomputation in hot paths
- Blocking I/O in async contexts
- Missing caching where appropriate

Ignore pre-existing issues. Focus only on changes introduced by this PR.

**Agent 3 – Git history context**
Read `git blame` and recent commit history of modified files. Identify bugs or regressions that only make sense with this historical context.

**Agent 4 – PR history**
Read previous PRs that touched the same files. Check if comments or issues raised in those PRs also apply here.

**Agent 5 – Code comment compliance**
Read code comments in modified files. Ensure the changes respect any guidance or invariants expressed in comments.

---

## Step 4 — Score each issue

For every issue found in step 3, launch a parallel Haiku agent that scores it 0–100:

| Score | Meaning |
|---|---|
| 0 | False positive, pre-existing, or doesn't hold up to scrutiny |
| 25 | Possible issue but uncertain; stylistic issue not in CLAUDE.md |
| 50 | Real but minor or infrequent |
| 75 | Highly likely real, important, or explicitly in CLAUDE.md |
| 100 | Confirmed issue that will occur frequently |

**Discard any issue scored below 75.** If none remain, skip to step 7 with "no issues found".

---

## Step 5 — Show report and ask for confirmation

Before posting anything to GitHub, output the final report (same format as step 7) and ask:

> "Would you like me to post these comments to the PR?"

Wait for explicit confirmation. If the user asks to remove or adjust specific issues, update accordingly and ask again. Only proceed after confirmation.

---

## Step 6 — Post inline review comments

Build a JSON payload and post all comments in a single review:

```bash
gh api repos/<owner>/<repo>/pulls/<number>/reviews --method POST --input /tmp/review_<number>.json
```

Build the JSON in Python to avoid shell escaping issues:

```python
import json, subprocess

comments = [
  {
    "path": "src/file.py",
    "position": 12,  # position within the diff hunk, NOT the file line number
    "body": "..."
  },
  # ...
]

review = {
  "body": "🔍 Code Review\n\n**Code issues found: N**\n\n| # | Severity | Comment |\n|---|----------|---------|\n| 1 | [Blocking] | [Short title](url) |",
  "event": "COMMENT",
  "comments": comments
}

with open("/tmp/review_<number>.json", "w") as f:
    json.dump(review, f)
```

### Comment body format

Each comment body must be **didactic and educational**, structured as:

```
[Blocking]

**Problem** — clear description of what is wrong and *why* it matters.

**Failure scenario** — concrete example showing when/how it breaks in production.

**Fix** — code suggestion with explanation of why the fix works.

**References** — (if applicable) link to relevant docs, RFC, or well-known article.
```

Severity to indicator mapping:
- 🔴 Blocker → `[Blocking]`
- 🟡 Warning → `[Suggestion]` or `[Blocking]` depending on impact
- 🔵 Suggestion → `[Suggestion]`
- Unclear intent → `[Question]`
- Positive highlight → `[Comment]`

NVC examples:
- `[Question]\n\nCould you clarify the purpose of this variable? I couldn't quite understand why it's needed here.`
- `[Suggestion]\n\nConsidering readability and maintainability, it might be worth extracting this block into a separate function.`
- `[Blocking]\n\nI found a bug on this line that could cause a system failure. We need to fix it before merging.`
- `[Comment]\n\nThe documentation is well written and helps understand the code logic. Great work!`

### Review body format

After posting, fetch comment IDs from the API response and build the review `body`:

```
🔍 Code Review

**Code issues found: N**

| # | Severity | Comment |
|---|----------|---------|
| 1 | [Blocking] | [Short title](https://github.com/owner/repo/pull/N#discussion_r<id>) |
| 2 | [Suggestion] | [Short title](url) |
```

Each row links directly to its inline comment using `html_url` from the API response, with a 3–5 word title summarizing the issue.

**Never include**: "🤖 Generated with Claude Code", "automated review", "generated by AI", or any attribution. Comments must read as written by a human engineer.

---

## Step 7 — Update PR description

Use a Haiku agent to:
1. Fetch the repo's PR template from `.github/PULL_REQUEST_TEMPLATE.md` via `gh api`
2. If no template exists, use the **Default PR Template** at the end of this skill
3. Compare the template with the current PR description and rebuild it section by section:
   - **Description**: list modified files/modules with a brief explanation of each change
   - **Motivation**: why the change was made, what problem it solves, ticket reference (pattern `[A-Z]+-[0-9]+`)
   - **Types of changes**: check applicable boxes based on actual diff
   - **Checklist**: check only items with evidence in the diff
   - Remove broken `diffhunk://` links, rewriting affected bullets in plain text
4. Update via `gh pr edit --body` only if changes are needed
5. Report what was changed (or "description already complete")

---

## Step 8 — Apply labels

1. Fetch available labels: `gh label list --repo <owner>/<repo> --json name --jq '.[].name'`
2. Based on the diff and issues found in step 3, select labels from the available list using this mapping:
   - Changes to docs/README/comments → `documentation` (if available)
   - New functionality added → `enhancement` or `feature` (if available)
   - Bug introduced or fixed → `bug` (if available)
   - Security issue found (score ≥ 75) → `security` (if available)
   - Breaking change → `breaking change` (if available)
   - Only select labels that **exist** in the repo — never invent labels
3. Apply selected labels: `gh pr edit <number> --repo <owner>/<repo> --add-label "<label1>,<label2>"`
4. Report which labels were applied (or "no matching labels found")

---

## Step 9 — Final report

```
### PR Review Report

**PR**: #[number] — [title]

**Summary**: [1-2 sentences]

**Structure**: [PASS / WARNING — brief note]

**Code issues found**: [N]

1. [Brief description] ([source: CLAUDE.md / bug / history / comment])
   [https://github.com/owner/repo/blob/<full-sha>/path/to/file.ext#L10-L15]

2. ...

*(or "No issues found")*
```

---

## Guidelines

- Use `gh` CLI for all GitHub interactions. Do not use WebFetch for GitHub URLs.
- Link to code using the **full commit SHA** (not `HEAD`): `https://github.com/owner/repo/blob/<sha>/file.ext#L10-L15`
- `position` in diff comments = line count from the start of the `@@` hunk (including the `@@` line as position 1), not the file line number
- Do not run builds or tests — assume CI handles that
- **Didactic tone**: explain *why* something is wrong at a conceptual level. A developer reading the comment should understand the underlying principle and apply it elsewhere
- **Nonviolent Communication**: prefix every comment with `[Blocking]`, `[Suggestion]`, `[Question]`, or `[Comment]`. Write with empathy — goal is growth, not criticism
- **Technical references**: when an issue relates to a known standard or documented behavior, add a `**References:**` section with real links only — never fabricate URLs
- **No AI attribution** anywhere in the payload

## False positives to avoid

- Pre-existing issues not introduced by this PR
- Issues a linter/compiler/typechecker would catch (assume CI runs those)
- Nitpicks a senior engineer would not raise in a real code review
- General concerns unless explicitly required by CLAUDE.md
- Issues silenced with lint-ignore comments
- Intentional changes clearly part of the PR's goal

---

## Default PR Template

Use when the repo has no `.github/PULL_REQUEST_TEMPLATE.md`:

```markdown
## Description

<!-- Describe your changes in detail. List modified files/modules with a brief explanation of each change. -->

## Motivation and Context

<!-- Why is this change required? What problem does it solve? -->
<!-- If it fixes an open issue or ticket, please reference it here (e.g. Closes PROJ-123) -->

## Types of changes

- [ ] Bug fix (change that fixes an issue)
- [ ] New feature (change which adds functionality)
- [ ] Documentation

## Checklist

- [ ] I have performed a self-review of my own code
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] I have updated the CHANGELOG
- [ ] I have updated the documentation accordingly
```
