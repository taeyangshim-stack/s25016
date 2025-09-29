# Repository Guidelines

## Project Structure & Module Organization
- Source lives in `src/`, grouped by domain (e.g., `src/core/`, `src/api/`).
- Tests mirror sources under `tests/` (e.g., `tests/core/test_utils.*`).
- Executables or entrypoints go in `cmd/` or `bin/`.
- Project scripts and automation in `scripts/` (bash/Make/Just).
- Docs and examples in `docs/` and `examples/`.

Example layout:
```
hexagon/
  src/                # implementation
  tests/              # mirrors src
  scripts/            # dev/build helpers
  .github/workflows/  # CI
```

## Build, Test, and Development Commands
- Run all tests: `scripts/test` or `make test` (add a wrapper script that calls your test runner).
- Format code: `scripts/format` or `make format`.
- Lint code: `scripts/lint` or `make lint`.
- Local run/dev: `scripts/dev` (start the app or watch mode).

Tip: Prefer small shell wrappers in `scripts/` so CI and local use the same entry points.

## Coding Style & Naming Conventions
- Indentation: 2 spaces (JS/TS), 4 spaces (Python). Max line length 100.
- Files: `snake_case` for Python, `kebab-case` for web assets, `CamelCase` for types/classes.
- Prefer pure, small functions; keep modules under ~400 lines.
- If using formatters/linters, adopt typical defaults (e.g., Black/ruff for Python; Prettier/ESLint for JS/TS).

## Testing Guidelines
- Place unit tests in `tests/` mirroring `src/` paths.
- Naming: Python `test_*.py`; JS/TS `*.spec.ts` or `*.test.ts`.
- Aim for ≥80% line coverage on changed code.
- Run fast unit tests by default; add integration tests under `tests/integration/`.

## Commit & Pull Request Guidelines
- Use Conventional Commits: `feat:`, `fix:`, `docs:`, `chore:`, `refactor:`, `test:`.
- Keep commits focused; one logical change per commit.
- PRs must include: clear description, motivation, screenshots (if UI), and linked issue (e.g., `Closes #123`).
- Ensure CI green: format, lint, and tests must pass. Include migration notes if behavior changes.

## Security & Configuration Tips
- Never commit secrets. Use environment variables and add `.env.example` for required keys.
- Validate inputs at boundaries; prefer least-privileged defaults.
- Document any ports, feature flags, or credentials in `docs/config.md`.

## Agent-Specific Instructions
- Follow this guide’s structure when adding files.
- Keep changes minimal and scoped; avoid unrelated refactors.
- Prefer script wrappers over duplicating command logic across tasks.
