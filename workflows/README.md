# Workflows

Reusable GitHub Actions workflows.

## review-issue.yml

Automatically reviews new issues using Claude AI. When an issue is opened, it posts a structured comment with Summary, Analysis, Implementation Options and Recommendation — and applies the appropriate labels.

### Setup

1. Copy `review-issue.yml` to `.github/workflows/` in your repository.
2. Add your Anthropic API key as a secret:
   ```bash
   gh secret set ANTHROPIC_API_KEY --repo <owner/repo>
   ```
3. Enable **Read and write permissions** for Actions in **Settings → Actions → General → Workflow permissions**.

### Customization

Edit the `availableLabels` array in the workflow to match the labels used in your repository.
