# GitHub Pages Deployment

This project is a simple static website deployed to GitHub Pages with GitHub Actions.

The workflow runs on every push to the `main` branch, but only when `index.html` changes. When triggered, it uploads the static website and deploys it to GitHub Pages.

## Files

- `index.html` - Static website entry point.
- `.github/workflows/deploy.yml` - GitHub Actions workflow for GitHub Pages deployment.

## GitHub Pages URL

After enabling GitHub Pages with GitHub Actions as the source, the site will be available at:

```text
https://<username>.github.io/gh-deployment-workflow/
```
