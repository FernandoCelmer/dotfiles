---
allowed-tools: Bash(gh issue list:*), Bash(gh issue view:*), Bash(gh repo list:*), Bash(gh repo view:*), Bash(gh api:*), Bash(gh issue comment:*), Bash(jq:*), Bash(python3:*)
description: Use this skill when the user asks to "review issues", "revisar issues", "ver issues abertas", "listar issues", "analisar issues", "checar issues" or wants to review open issues across their repositories.
version: 1.0.0
---

# Review Issues

Analyze open issues across one or more repositories. Identify priorities, patterns, duplicates and gaps.

Make a todo list and track progress through all steps.

---

## Step 0 — Check for single issue

If the user provided a specific issue URL (e.g. `https://github.com/owner/repo/issues/42`) or a repo + issue number, treat this as **single-issue mode**:

1. Extract owner, repo, and issue number from the URL or arguments.
2. Fetch the issue:
```bash
gh issue view <number> --repo <owner/repo> --comments
```
3. Analyze the issue and produce a structured review **in English** covering:
   - **Summary**: one-paragraph description of what is being requested or reported.
   - **Analysis**: relevance, complexity, and current status.
   - **Implementation Options**: list 2–4 concrete options with trade-offs.
   - **Recommendation**: the preferred approach and why.
4. Post the review as a comment on the issue:
```bash
gh issue comment <number> --repo <owner/repo> --body "<review>"
```

Format the comment in Markdown. Do not mention AI or automated tools in the comment.

After posting, show the user the comment that was posted and stop — do not continue to Step 1.

---

## Step 1 — Determine scope

If the user specified a repo or list of repos, use those. Otherwise:

```bash
gh repo list --limit 50 --json name,nameWithOwner,isArchived,isPrivate --jq '[.[] | select(.isArchived == false)]'
```

Ask the user to confirm which repos to include if there are many. If they said "all", proceed with all non-archived repos.

---

## Step 2 — Collect open issues

For each repo in scope:

```bash
gh issue list --repo <owner/repo> --state open --limit 100 --json number,title,body,labels,assignees,createdAt,updatedAt,comments,milestone,url
```

Collect all results. If a repo has 0 open issues, skip it silently.

---

## Step 3 — Run parallel analysis agents (Sonnet)

Run the following agents in parallel over the collected issues:

**Agent 1 – Categorization**
For each issue, assign:
- **Type**: `bug`, `feature`, `improvement`, `question`, `docs`, `security`, `chore`, `unclear`
- **Area**: infer the affected area from title/body (e.g. `auth`, `api`, `ui`, `db`, `infra`, `tests`)
- **Missing labels**: identify if the issue has no labels or incorrect labels

**Agent 2 – Priority scoring**
Score each issue 1–5 for urgency:
- **5 – Critical**: security vulnerability, data loss, production outage, blocker
- **4 – High**: significant bug affecting users, broken core functionality
- **3 – Medium**: bug with workaround, impactful feature request
- **2 – Low**: minor bug, nice-to-have feature
- **1 – Backlog**: unclear, stale, or low-impact

Base the score on: title, body, labels, number of comments, age (older + many comments = more relevant), and keywords like "crash", "security", "data loss", "broken".

**Agent 3 – Duplicate and relationship detection**
Find issues that:
- Describe the same problem (duplicates)
- Are closely related (same root cause or same feature area)
- Reference each other or overlap in scope

Group them and flag the primary issue in each group.

**Agent 4 – Stale issue detection**
Flag issues that:
- Have had no activity (comments, updates) for more than 30 days
- Have no assignee and no label
- Have a body that is too vague to act on (no reproduction steps for bugs, no acceptance criteria for features)

**Agent 5 – Quick wins**
Identify issues that:
- Are small in scope and clearly defined
- Have no dependencies
- Could be resolved in a short session
- Are good candidates for `good first issue`

---

## Step 4 — Build the report

Output a structured report:

---

### Issues Report

**Repos analyzed**: N
**Total open issues**: N
**Date**: today

---

#### By Priority

| # | Repo | Issue | Type | Priority | Age |
|---|------|-------|------|----------|-----|
| 1 | owner/repo | [#42 Title](url) | bug | 🔴 Critical | 3d |
| 2 | ... | ... | ... | 🟠 High | 7d |

Priority legend: 🔴 Critical · 🟠 High · 🟡 Medium · 🔵 Low · ⚪ Backlog

---

#### Duplicates & Related Issues

Group related issues and indicate which is the primary:

- **Group: Auth failures on OAuth login**
  - [#12 OAuth login crashes on mobile](url) ← primary
  - [#18 Login fails after token refresh](url) ← likely duplicate
  - [#31 Session not persisted after Google login](url) ← related

---

#### Stale Issues (no activity > 30 days)

List with last activity date and a suggested action: close, request more info, or reassign.

---

#### Quick Wins

List issues that could be tackled quickly. Mark candidates for `good first issue`.

---

#### Summary by Type

| Type | Count |
|------|-------|
| bug | N |
| feature | N |
| improvement | N |
| question | N |
| docs | N |
| security | N |
| unclear | N |

---

#### Missing Labels

List issues with no labels and a suggested label based on content.

---

## Step 5 — Ask for actions

After the report, ask the user:

> "Would you like me to:
> a) Add labels to issues missing them
> b) Close stale issues (with a comment)
> c) Link duplicate issues with a comment
> d) All of the above
> e) Nothing, report only"

Wait for confirmation before taking any action.

---

## Step 6 — Apply actions (if confirmed)

**Add labels:**
```bash
gh issue edit <number> --repo <owner/repo> --add-label "<label>"
```

**Close stale issue with comment:**
```bash
gh issue comment <number> --repo <owner/repo> --body "Closing this issue due to inactivity. Feel free to reopen if the problem persists or provide more details."
gh issue close <number> --repo <owner/repo>
```

**Link duplicates:**
```bash
gh issue comment <number> --repo <owner/repo> --body "This issue appears to be related to #<primary>. Linking for tracking."
```

Do not include AI attribution in any comment.

---

## Guidelines

- Use `gh` CLI for all GitHub interactions
- Never mention AI or automated tools in comments posted to GitHub
- If a repo has no open issues, skip it without mentioning it
- Focus on actionable insights — avoid listing every issue without adding value
- When the scope is large (50+ issues), summarize by category instead of listing individually
