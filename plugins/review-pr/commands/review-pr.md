---
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr list:*), Bash(git log:*), Bash(git diff:*)
description: Review a pull request. Analyzes the diff, description and context to provide detailed feedback on code quality, bugs, security and best practices.
---

## Task

Review the pull request provided by the user. If no PR number or URL is given, list open PRs and ask which one to review.

## Steps

1. Fetch PR metadata:
```bash
gh pr view <number> --json title,body,author,baseRefName,headRefName,additions,deletions,changedFiles,commits
```

2. Fetch the full diff:
```bash
gh pr diff <number>
```

3. Analyze and provide a structured review.

## Review format

### Overview
- **Title**: PR title
- **Author**: who opened it
- **Changes**: +additions / -deletions across N files

### Summary
Brief description of what the PR does based on the description and diff.

### Review

For each changed file or logical group, comment on:

- **Correctness**: logic errors, edge cases, off-by-one, null handling
- **Security**: injections, exposed secrets, insecure defaults, improper auth
- **Performance**: unnecessary loops, N+1 queries, missing indexes, large allocations
- **Readability**: naming, complexity, missing comments on non-obvious logic
- **Tests**: coverage, missing cases, flaky patterns

Use this severity scale:
- 🔴 **Blocker** — must fix before merge
- 🟡 **Warning** — should fix, but not blocking
- 🔵 **Suggestion** — optional improvement
- ✅ **Good** — worth highlighting positive patterns

### Verdict

One of:
- ✅ **Approve** — ready to merge
- 🟡 **Approve with suggestions** — minor issues, author can decide
- 🔴 **Request changes** — blockers found, must be addressed
