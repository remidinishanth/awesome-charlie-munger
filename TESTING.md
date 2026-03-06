# Local Testing Guide

Test the GitHub Pages site locally before pushing to avoid broken builds.

## Prerequisites

- **Ruby 3.1+** (the GitHub Actions workflow uses Ruby 3.1)
- **Bundler** gem

### Install Ruby (macOS)

```bash
# rbenv (recommended — avoids version conflicts with system Ruby)
brew install rbenv ruby-build
rbenv install 3.1.6
rbenv global 3.1.6
```

> **Note:** Homebrew's `brew install ruby` gives you Ruby 4.0+ which is too new for `github-pages` gem (Jekyll 3.9). Use rbenv with Ruby 3.1.x instead.

### Install Bundler

```bash
gem install bundler
```

## Setup (first time only)

```bash
cd awesome-charlie-munger
bundle install
```

## Run Locally

```bash
bundle exec jekyll serve
```

The site will be available at **http://localhost:4000**.

### With live reload (auto-refreshes browser on changes):

```bash
bundle exec jekyll serve --livereload
```

### With drafts and verbose output:

```bash
bundle exec jekyll serve --livereload --drafts --verbose
```

## What to Check

Before pushing changes, verify:

### Landing Page (`/` or `/index.html`)
- [ ] Hero section renders with gradient background
- [ ] "Browse the Collection" and "View on GitHub" buttons work
- [ ] Navigation grid shows 4 cards (Books, Speeches, Videos, Book Recommendations)
- [ ] Featured book section displays with purple gradient
- [ ] All links navigate to correct sections in README.html

### Main Content (`/README.html`)
- [ ] Table of contents links work (anchor navigation)
- [ ] Talks section renders as a card grid (not plain list)
- [ ] PDF "View PDF" buttons are red and link to correct files
- [ ] Bookshelf images are inside a collapsible `<details>` element
- [ ] Charlie Munger portrait image loads
- [ ] Poor Charlie's Almanack banner image loads
- [ ] All external links open correctly (Amazon, Goodreads, YouTube, etc.)

### Responsive Design
- [ ] Resize browser to 768px width — cards should stack to single column
- [ ] Navigation grid collapses gracefully on mobile
- [ ] Text remains readable at all sizes

### Common Issues

| Issue | Fix |
|-------|-----|
| `bundle install` fails | Check Ruby version: `ruby --version` (need 3.1+) |
| CSS not loading | Verify `_config.yml` has `theme: minima` |
| Images not showing | GitHub-hosted images require internet connection |
| PDFs not accessible | Ensure `resources/talks/` directory exists with PDF files |
| Redirect loop | Check that `index.md` has `layout: default` front matter |

## Quick Smoke Test (no Ruby needed)

If you can't set up Ruby locally, you can do a quick HTML check:

```bash
# Check for broken internal links in README.md
grep -oP '\[.*?\]\((resources/[^)]+)\)' README.md | while read -r line; do
  file=$(echo "$line" | grep -oP '\((.*?)\)' | tr -d '()')
  if [ ! -f "$file" ]; then
    echo "BROKEN: $file"
  fi
done

# Validate HTML structure (requires html5validator: pip install html5validator)
# bundle exec jekyll build
# html5validator --root _site/
```

## CI/CD

The site auto-deploys via GitHub Actions (`.github/workflows/jekyll.yml`) on push to `main`. The workflow:
1. Checks out the repo
2. Sets up Ruby 3.1 with bundler caching
3. Builds with Jekyll
4. Deploys to GitHub Pages
