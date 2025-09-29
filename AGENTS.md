# Repository Guidelines

## Project Structure & Module Organization
- Root contains static artifacts, e.g., `상하축이슈_대시보드.html`.
- Work folder: `250917_상하축이슈/`
  - `01_문제점분석/` (analysis), `02_대책수립/` (countermeasures), `03_일정관리/` (schedule),
    `04_작업진행/` (progress), `05_문서자료/` (docs), `99_공유폴더/` (shared).
- Agent notes: `.claude/`, `CLAUDE.md`. Keep these untouched unless updating agent docs.

## Build, Test, and Development Commands
- No build step (static HTML/Markdown).
- Local preview (serves current directory):
  - `python3 -m http.server 8000` → open `http://localhost:8000/상하축이슈_대시보드.html`.
- Validate HTML (manual): open in a browser and inspect console for errors.

## Coding Style & Naming Conventions
- Encoding: UTF-8. Line endings: LF. Indent: 2 spaces (HTML/JSON/YAML), 4 for Python snippets.
- Filenames: prefer the project pattern `YYMMDD_작성자_제목.확장자` for work items in `250917_상하축이슈/*`.
- Keep existing Korean directory names as-is; avoid renames that break links.
- HTML: semantic tags, lowercase attributes, double quotes, relative paths.
- Markdown: `#`-based headings, fenced code blocks, links relative to repo root.

## Testing Guidelines
- Manual checks: open HTML in latest Chrome/Edge, verify layout, images, and relative links.
- Cross-check navigation from `상하축이슈_대시보드.html` to target files.
- If adding scripts, ensure they run without external CDNs when offline (or justify usage).

## Commit & Pull Request Guidelines
- Commits: concise and scoped. Conventional prefix recommended:
  - `feat(progress): add 240923 update log`
  - `fix(dashboard): correct relative link to 분석자료`
  - `docs(plan): update 일정 마일스톤`
- PRs must include: purpose, scope, before/after screenshots for UI/HTML, affected paths, and any follow-ups.
- Link related tasks/issues and reference the folder(s) touched.

## Security & Configuration Tips
- Do not commit sensitive data. Redact names/IDs in shared docs.
- Large binaries go to `99_공유폴더/` with a short README pointer if needed.
- Keep paths relative; avoid absolute machine-specific paths.

## Agent-Specific Instructions
- Follow the folder taxonomy above; place new content in the correct stage folder.
- When adding or moving files, update any linking HTML/Markdown and verify via local preview.
