# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the `s25015` subdirectory within the larger FEM + AI research repository. This project is part of a multi-project workspace structure:

- Parent directory contains the main `workspace/` with complete FEM + AI framework
- See `/home/qwe/works/CLAUDE.md` for comprehensive repository documentation
- This subdirectory is currently empty and ready for project-specific development

## Common Commands

Since this directory is currently empty, commands will depend on the technology stack chosen for development. Common patterns from the parent repository include:

**If developing Python projects:**
- Follow the workspace pattern: `src/`, `tests/`, `examples/` structure
- Use `make` commands or PowerShell scripts for build/test automation
- Python 3.10+ with virtual environment recommended

**If developing web projects:**
- Follow the workspace/web pattern with React + Vite
- Standard npm commands: `npm install`, `npm run dev`, `npm run build`

**If creating documentation or planning:**
- Use markdown files for documentation
- Follow conventional commit patterns (feat:, fix:, docs:, etc.)

## Development Workflow

1. **Environment Setup**: Create appropriate project structure based on requirements
2. **Code Style**: Follow parent repository conventions (4-space indentation, UTF-8, LF line endings)
3. **Testing**: Mirror the `src/` structure in `tests/` for unit tests
4. **Integration**: Consider how this project connects with the main workspace FEM/AI framework

## Architecture Considerations

When developing in this directory:

- **Integration**: Consider how to integrate with existing workspace utilities (`src/utils/`)
- **Experiment Tracking**: Use the metadata system from workspace for consistent result tracking
- **Collaboration**: Leverage workspace collaboration tools for team coordination
- **Technology Stack**: Align with workspace standards (Python + pure implementations, React frontend)

## Important Files

- `../CLAUDE.md` - Main repository documentation and commands
- `../workspace/` - Complete FEM + AI framework for reference and integration