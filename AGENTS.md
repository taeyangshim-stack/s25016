# Repository Guidelines

> S25016 Project: Robot system development, DeviceNet communication, precision measurement solutions

## Project Structure

```
s25016/
├── api/                              # Vercel serverless functions (Node.js)
├── cloudinary-uploader/              # File upload CLI + server
├── RAPID/                            # ABB RAPID robot code workspace
│   ├── SpGantry_*/                   # Robot backups
│   ├── PlanB_ToolControl2/           # Tool control modules
│   └── scripts/                      # RAPID validation scripts
├── 250917_상하축이슈/                # Primary workspace (issue lifecycle)
│   ├── 01_문제점분석/                # Analysis
│   ├── 02_대책수립/                  # Countermeasures
│   ├── 03_일정관리/                  # Scheduling
│   ├── 04_작업진행/                  # Execution
│   ├── 05_문서자료/                  # Documentation
│   └── 99_공유폴더/                  # Heavy assets
├── B_Line_EventMessage/              # Robot event log analysis
├── punchlist/                        # Punchlist management app
├── projects/                         # Sub-projects (hexagon, work-management)
├── scripts/                          # Shell/Python utility scripts
└── index.html                        # Main dashboard
```

**Naming convention for new files:** `YYMMDD_작성자_제목.ext` (e.g., `251028_심태양_진행현황.md`)

## Build, Test & Development

### Quick Start
```bash
npm install                           # Install shared dependencies (Node.js >=18.x)
python3 -m http.server 8000           # Serve static content at localhost:8000
```

### Vercel Development
```bash
vercel dev                            # Local Vercel dev server at localhost:3000
vercel --prod                         # Production deployment
```

### Cloudinary Uploader
```bash
cd cloudinary-uploader
npm install
npm run server                        # Local server at localhost:3000
node uploader.js ./files --folder=s25016/docs  # CLI upload
```

### RAPID Code Validation
```bash
cd RAPID/scripts
python3 validate_and_fix_rapid.py     # Validate RAPID syntax
python3 check_version.py              # Check version consistency
```

### Testing
- **No automated test suite** - manual UI verification is primary
- Serve locally, open in Chrome/Edge, validate:
  - Navigation and page loads
  - Console output (no errors)
  - Asset loading
- When adding scripts, provide lightweight HTML harness or CLI example

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/upload` | POST | Cloudinary file upload |
| `/api/files?folder=` | GET | List uploaded files |
| `/api/folders` | GET | List Cloudinary folders |
| `/api/punchlist` | GET/POST | Punchlist CRUD |
| `/api/work-records` | GET/POST | Work records management |

## Code Style

### JavaScript (Vercel Serverless, Node.js)
```javascript
// CommonJS imports
const cloudinary = require('cloudinary').v2;
const { IncomingForm } = require('formidable');

// Prefer const/let, never var
const PORT = process.env.PORT || 3000;

// Async/await for async operations
module.exports = async (req, res) => {
  try {
    const result = await cloudinary.uploader.upload(file);
    res.status(200).json({ success: true, url: result.secure_url });
  } catch (error) {
    console.error('Upload error:', { message: error.message, stack: error.stack });
    res.status(500).json({ success: false, error: error.message });
  }
};

// CORS headers for API functions
res.setHeader('Access-Control-Allow-Origin', '*');
res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,POST,PUT,DELETE');
```

### Python
```python
#!/usr/bin/env python3
"""Module docstring with brief description."""

import json
from pathlib import Path
from collections import defaultdict

class EventLogAnalyzer:
    """Class docstring."""
    
    def __init__(self, base_path):
        self.base_path = Path(base_path)
    
    def scan_logs(self):
        """Method docstring."""
        # Handle multiple encodings gracefully
        encodings = ['utf-8', 'cp949']
        for encoding in encodings:
            try:
                with open(filepath, 'r', encoding=encoding) as f:
                    return f.read()
            except UnicodeDecodeError:
                continue

if __name__ == "__main__":
    main()
```

### HTML
```html
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Page Title</title>
</head>
```
- Lowercase attribute names, double-quoted values
- 2-space indentation
- UTF-8 encoding with Korean support

### Formatting Rules
| Language | Indent | Line endings |
|----------|--------|--------------|
| HTML/JSON/YAML | 2 spaces | LF |
| JavaScript | 2 spaces | LF |
| Python | 4 spaces | LF |
| Markdown | 2 spaces | LF |

## Error Handling

### JavaScript
```javascript
try {
  const result = await operation();
} catch (error) {
  console.error('Operation failed:', {
    message: error.message,
    name: error.name,
    http_code: error.http_code,
    stack: error.stack
  });
  res.status(500).json({ success: false, error: error.message });
}
```

### Python
```python
try:
    result = risky_operation()
except (json.JSONDecodeError, TypeError) as e:
    print(f"Error: {e}", file=sys.stderr)
    return None
```

## Commit & PR Guidelines

### Conventional Commits
```bash
feat(dashboard): add 240923 update log
fix(api): correct file upload path handling
docs(plan): refresh project schedule
refactor(uploader): simplify error handling
```

### PR Requirements
- State purpose and scope
- List impacted folders
- Include before/after screenshots for HTML changes
- Reference related tasks or issues

## Security & Configuration

- **Never commit secrets** - use environment variables
- `.env` files are gitignored
- Store configs in `99_공유폴더/README` with redacted placeholders
- Large binaries belong in `99_공유폴더/` with pointer documents
- Use relative paths for portability

### Environment Variables (Cloudinary)
```env
CLOUDINARY_CLOUD_NAME=your_cloud_name
CLOUDINARY_API_KEY=your_api_key
CLOUDINARY_API_SECRET=your_api_secret
CLOUDINARY_UPLOAD_FOLDER=s25016
```

## Agent-Specific Instructions

1. **File Organization**: Place artifacts in stage-matched folders under `250917_상하축이슈/`
2. **Dashboard Updates**: Update index.html or relevant dashboards when adding deliverables
3. **Link Verification**: Verify all links work after edits (Korean paths are case-sensitive)
4. **Preserve History**: Never delete prior analysis without approval; append dated sections
5. **Korean Names**: Preserve Korean directory/file names verbatim to maintain links
6. **Offline Compatibility**: Confirm scripts and pages work without network when possible
