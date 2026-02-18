# Resume Builder - Development Setup

Quick start guide for local development.

## One-Time Setup

### Prerequisites
- Node.js 18+
- Python 3.8+
- Git

### Install pdflatex

**Windows:**
- Download MiKTeX from https://miktex.org/download
- Run installer and add to PATH
- Restart terminal

**macOS:**
```bash
brew install basictex
```

**Linux:**
```bash
sudo apt-get install texlive-latex-base
```

### Verify Installation
```bash
pdflatex --version
python --version
node --version
```

## Start Development

### Terminal 1 - Frontend

```bash
cd client
npm install     # First time only
npm run dev
# Runs on http://localhost:3000
```

### Terminal 2 - Backend

```bash
cd server

# First time setup
python -m venv venv
# Windows: venv\Scripts\activate
# macOS/Linux: source venv/bin/activate

pip install -r requirements.txt
python main.py
# Runs on http://localhost:8000
```

## Quick Testing

1. Open http://localhost:3000
2. Click "Manual Entry"
3. Fill in some info
4. Click "Generate Resume & Calculate ATS Score"
5. View ATS score in sidebar
6. Select template and click "Download as PDF"

## File Structure Reference

- `client/` - Next.js frontend (TypeScript, Tailwind)
- `server/` - FastAPI backend (Python)
- `README.md` - Full documentation

## Environment Variables

### Frontend (client/.env.local)
```
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Backend (server/.env)
```
DEBUG=True
CORS_ORIGINS=["http://localhost:3000"]
```

## Useful Commands

### Frontend
```bash
npm run dev      # Start dev server
npm run build    # Build for production
npm run lint     # Check linting
```

### Backend
```bash
python main.py   # Start dev server
```

## Troubleshooting

**PDF download fails?**
- Check pdflatex is installed: `pdflatex --version`
- Check backend logs for errors

**CORS error?**
- Make sure backend CORS_ORIGINS includes http://localhost:3000

**Port already in use?**
- Change Next.js port: `npm run dev -- -p 3001`
- Change FastAPI port: Edit main.py line 290

## Next Steps

- See [FRONTEND.md](client/FRONTEND.md) for frontend development
- See [BACKEND.md](server/BACKEND.md) for backend development
- See [README.md](README.md) for deployment instructions
