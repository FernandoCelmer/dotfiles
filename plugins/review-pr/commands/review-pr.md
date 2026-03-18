---
allowed-tools: Bash(gh pr view:*), Bash(gh pr diff:*), Bash(gh pr list:*), Bash(git log:*), Bash(git diff:*), Bash(git ls-files:*)
description: Review a pull request with detailed feedback on code quality, security, project structure, design patterns and best practices.
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

3. Analyze and provide a structured review covering all dimensions below.

---

## Review dimensions

### 1. Correctness & Logic
- Logic errors, wrong conditions, inverted boolean checks
- Off-by-one errors, boundary conditions
- Null/undefined/empty handling
- Async/concurrency issues (race conditions, missing awaits, deadlocks)
- Error handling: silent catches, swallowed exceptions, missing rollbacks

### 2. Security (OWASP Top 10 + extras)
- Injection: SQL, command, LDAP, XPath, template injection
- Broken authentication: weak tokens, missing expiration, insecure session handling
- Sensitive data exposure: secrets in code, logs, responses or error messages
- Broken access control: missing authorization checks, IDOR, privilege escalation
- Security misconfiguration: permissive CORS, debug mode on, default credentials
- XSS: unescaped output, unsafe innerHTML, missing CSP
- Insecure deserialization
- Using components with known vulnerabilities (outdated deps)
- Insufficient logging of security events
- SSRF, path traversal, open redirects

### 3. Project Structure & Architecture
- Files placed in wrong layers (e.g. business logic in controllers, DB queries in views)
- Violated separation of concerns
- Circular dependencies
- Hardcoded configuration that should be in env vars or config files
- Missing or broken dependency injection
- Inconsistency with existing project conventions (naming, folder structure, module organization)
- Dead code, commented-out blocks left in

### 4. Design Patterns & Best Practices
- God classes or functions doing too much (violates SRP)
- Missing abstraction where duplication exists (violates DRY)
- Premature optimization or over-engineering
- Inappropriate use of patterns (e.g. Singleton hiding global state)
- Missing patterns where they would help (Strategy, Factory, Repository, etc.)
- Law of Demeter violations (excessive chaining)
- Feature envy (method using another class's data more than its own)
- Magic numbers and strings without named constants

### 5. Code Quality
- Function/variable naming: unclear, misleading, inconsistent
- Functions too long or with too many parameters
- Deeply nested code (arrow anti-pattern)
- Missing or inadequate comments on non-obvious logic
- Inconsistent formatting or style vs the rest of the codebase
- Return types and error contracts unclear or undocumented

### 6. Tests
- Missing tests for new behavior
- Missing edge case coverage (empty input, max values, error paths)
- Tests testing implementation instead of behavior
- Mocking too much (fragile tests, false confidence)
- Flaky tests (time-dependent, order-dependent, network-dependent)
- No integration or contract test where needed

### 7. Performance
- N+1 queries
- Missing pagination on unbounded queries
- Unnecessary re-renders or recomputations
- Large memory allocations in hot paths
- Missing caching where appropriate
- Blocking I/O in async contexts

---

## Review format

### Overview
- **Title**: PR title
- **Author**: who opened it
- **Base → Head**: branch names
- **Changes**: +additions / -deletions across N files

### Summary
What the PR does, in 2-3 sentences based on the description and diff.

### Issues found

Group findings by file or feature area. For each issue use:

```
[SEVERITY] Category — short title
File: path/to/file.ext (line N)
Problem: what is wrong and why it matters
Suggestion: what to do instead (with code example if helpful)
```

Severity scale:
- 🔴 **Blocker** — must fix before merge (bugs, security vulnerabilities, broken contracts)
- 🟡 **Warning** — should fix (bad patterns, missing tests, structural issues)
- 🔵 **Suggestion** — optional improvement (readability, minor refactors)
- ✅ **Good** — highlight positive patterns worth keeping

### Verdict

- ✅ **Approve** — ready to merge
- 🟡 **Approve with suggestions** — minor issues, author decides
- 🔴 **Request changes** — blockers or security issues must be addressed first
