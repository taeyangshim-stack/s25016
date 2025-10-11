# Repository Guidelines

## Project Structure & Module Organization
- Root mixes static dashboards (`상하축이슈_대시보드.html`) with project folders. Treat the root as read-only reference material unless a dashboard or index update is required.
- `250917_상하축이슈/` is the primary workspace. Subfolders map to the issue lifecycle: `01_문제점분석/` (analysis) through `04_작업진행/` (execution), `05_문서자료/` (supporting docs), and `99_공유폴더/` (heavy assets). Create new notes inside the correct stage folder using the `YYMMDD_작성자_제목.ext` convention.
- Auxiliary domains live at the root (`hexagon/`, `cloudinary-uploader/`, `api/`, `projects/`). Respect their internal structure; place new HTML beside peer files and keep assets local.
- Agent knowledge bases (`.claude/`, `CLAUDE.md`) are authoritative references; do not edit unless you are updating agent processes.

## Build, Test, and Development Commands
- `npm install` (root): installs shared dependencies used by scripts and serverless functions.
- `python3 -m http.server 8000` (root): serves static content for manual review at `http://localhost:8000/상하축이슈_대시보드.html`.
- `cd cloudinary-uploader && npm run server`: launches the local uploader backend. Keep `.env` secrets out of version control.
- `vercel --prod`: deploys Vercel-hosted components. Confirm `vercel.json` before publishing.

## Coding Style & Naming Conventions
- Encoding UTF-8, LF endings. HTML/JSON/YAML: 2-space indent; Python snippets/scripts: 4 spaces; JavaScript follows existing style, preferring `const`/`let`.
- Keep Korean directory names verbatim to preserve links. Use lowercase attribute names and double-quoted values in HTML.
- Markdown uses `#` headings, fenced code blocks, and relative links. Include brief callouts instead of long paragraphs.

## Testing Guidelines
- Manual UI verification is primary: serve locally, open in current Chrome/Edge, validate navigation, console output, and asset loads.
- When scripts are added, provide a lightweight HTML harness or CLI example and confirm offline compatibility. Document known limitations in the same folder.
- No automated test suite is configured; if introducing one, colocate configs under `scripts/` and document invocation in this guide.

## Commit & Pull Request Guidelines
- Use concise commits with conventional-style scopes, e.g., `feat(progress): add 240923 update log`, `fix(dashboard): correct 분석자료 link`, `docs(plan): refresh 일정`.
- PRs must state purpose, scope, impacted folders, and include before/after screenshots for HTML changes. Reference related tasks or issues and flag follow-up actions.

## Security & Configuration Tips
- Keep secrets out of the repo. Store temporary configs locally or in `99_공유폴더/README` with redacted placeholders.
- Large binaries belong in `99_공유폴더/` with a pointer document.
- Use relative paths in HTML/Markdown so previews and deployments remain portable.

## Agent-Specific Instructions
- Organize new artifacts in the stage-matched folder, update dashboards or indexes when adding deliverables, and verify links post-edit.
- Avoid deleting prior analysis without stakeholder approval; instead, append dated sections or provide change logs.
