# Resume Builder - Installation & Setup Guide

## Complete Setup Instructions

### Step 1: Prerequisites Installation

#### System Requirements
- **CPU**: 2+ cores
- **RAM**: 4GB minimum
- **Storage**: 2GB free space
- **OS**: Windows, macOS, or Linux

#### Required Software

**1. Install Node.js (18+)**
- Download from https://nodejs.org/
- Verify: `node --version` && `npm --version`

**2. Install Python (3.8+)**
- Download from https://www.python.org/
- Verify: `python --version`

**3. Install Git (Optional but recommended)**
- Download from https://git-scm.com/
- Verify: `git --version`

**4. Install LaTeX (Required for PDF generation)**

**Windows:**
```
1. Download MiKTeX from https://miktex.org/download
2. Run installer
3. Choose "Install missing packages on-the-fly" → Yes
4. Restart your computer
5. Verify: pdflatex --version
```

**macOS:**
```bash
# Install Homebrew first if needed: /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install basictex
sudo tlmgr update --self
sudo tlmgr install titlesec
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt-get update
sudo apt-get install texlive-latex-base texlive-fonts-recommended texlive-latex-extra
```

### Step 2: Clone Repository

```bash
# Clone from GitHub
git clone https://github.com/yourusername/resume-builder.git
cd resume-builder

# Or navigate to existing directory
cd c:\Users\Admin\Desktop\resume3
```

### Step 3: Backend Setup

```bash
# Navigate to server directory
cd server

# Create Python virtual environment
python -m venv venv

# Activate virtual environment
# Windows:
venv\Scripts\activate

# macOS/Linux:
source venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Create .env file
echo DEBUG=True > .env
echo ATS_API_KEY=your_key >> .env
echo ENABLE_ATS_API=False >> .env
echo CORS_ORIGINS=["http://localhost:3000"] >> .env

# Test the setup
python -c "from main import app; print('✓ Backend imports working')"
```

### Step 4: Frontend Setup

```bash
# Navigate to client directory
cd ../client

# Install npm dependencies
npm install

# Create .env.local file
echo NEXT_PUBLIC_API_URL=http://localhost:8000 > .env.local

# Test the setup
npm run lint --if-present
```

### Step 5: Start Development Servers

**Terminal 1 - Start Backend:**
```bash
cd server
# Activate venv if not already active
source venv/bin/activate  # macOS/Linux
# or: venv\Scripts\activate  # Windows

python main.py

# Expected output:
# INFO:     Uvicorn running on http://0.0.0.0:8000
# Press CTRL+C to quit
```

**Terminal 2 - Start Frontend:**
```bash
cd client
npm run dev

# Expected output:
# ▲ Next.js
# Local:        http://localhost:3000
# Press 'q' to quit
```

### Step 6: Verify Installation

1. **Check Backend**
   - Open http://localhost:8000/health in browser
   - Expected: `{"status":"ok","service":"Resume Builder API"}`

2. **Check Frontend**
   - Open http://localhost:3000 in browser
   - Expected: Resume Builder UI loads

3. **Test Upload**
   - Create a simple text file
   - Try uploading (should give format error, which means it's working)

## Docker Setup (Alternative)

### One-Command Setup

```bash
# Make sure Docker is installed
docker --version

# Start both frontend and backend
docker-compose up -d

# Check services
docker-compose ps

# Stop services
docker-compose down
```

### Docker Individual Containers

```bash
# Build backend
cd server
docker build -t resume-backend .
docker run -p 8000:8000 resume-backend

# Build frontend (separate terminal)
cd client
docker build -t resume-frontend .
docker run -p 3000:3000 resume-frontend
```

## Troubleshooting Installation

### Issue: "pdflatex not found"
**Solution:**
```bash
# Verify LaTeX is installed
pdflatex --version

# If not, install:
# Windows: Reinstall MiKTeX and restart
# macOS: brew install basictex && sudo tlmgr update --self
# Linux: sudo apt-get install texlive-latex-base
```

### Issue: "Python module not found"
```bash
# Verify venv is activated (line should show "(venv)" prefix)
which python  # or: where python

# If wrong Python:
# Windows: venv\Scripts\python -m pip install -r requirements.txt
# macOS/Linux: source venv/bin/activate && pip install -r requirements.txt
```

### Issue: "Port 3000/8000 already in use"
```bash
# Find and kill process
# Windows: netstat -ano | findstr :3000
# macOS/Linux: lsof -i :3000

# Or use different port:
# Frontend: npm run dev -- -p 3001
# Backend: Change in main.py (line 290)
```

### Issue: "npm install fails"
```bash
# Clear npm cache
npm cache clean --force

# Delete node_modules and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Issue: "CORS error in browser"
```bash
# Verify backend is running on port 8000
# Check frontend .env.local has:
NEXT_PUBLIC_API_URL=http://localhost:8000

# Check backend .env has:
CORS_ORIGINS=["http://localhost:3000"]
```

## Verification Checklist

After setup, verify each item:

```
□ Node.js installed (npm --version)
□ Python installed (python --version)
□ pdflatex installed (pdflatex --version)
□ Backend venv created and activated
□ Backend dependencies installed (pip list | grep fastapi)
□ Frontend dependencies installed (npm list | grep next)
□ .env files created and configured
□ Backend starts without errors
□ Frontend starts without errors
□ http://localhost:3000 loads in browser
□ http://localhost:8000/health returns JSON
□ Can fill form and see preview
□ ATS score calculates
□ Can download PDF/DOCX
```

## Development Workflow

### Daily Development

```bash
# Terminal 1
cd resume3/server
source venv/bin/activate  # or: venv\Scripts\activate
python main.py

# Terminal 2
cd resume3/client
npm run dev
```

### Code Changes

- **Frontend**: Changes auto-reload (Fast Refresh)
- **Backend**: Changes auto-reload if DEBUG=True
- **Dependencies**: Need to restart servers

### Common Development Commands

```bash
# Backend
cd server
python main.py              # Start dev
pip install package-name    # Install package
pytest -v                   # Run tests

# Frontend
cd client
npm run dev                 # Start dev
npm run lint               # Check code
npm run build              # Production build
npm test                   # Run tests
```

## Production Deployment Preview

### Deploy Frontend to Vercel

```bash
# Install Vercel CLI
npm i -g vercel

# In client directory
cd client
vercel

# Follow prompts, set env vars, deploy
```

### Deploy Backend to Render

1. Push to GitHub
2. Sign up at https://render.com/
3. Create New → Web Service
4. Connect GitHub repo
5. Set environment variables
6. Deploy

## Next Steps

1. **Read Documentation**
   - Start with [QUICKSTART.md](QUICKSTART.md)
   - Then [README.md](README.md)
   - Finally [API.md](API.md)

2. **Explore the Code**
   - Frontend components in `client/components/`
   - Backend modules in `server/`
   - Check inline comments

3. **Try Features**
   - Test manual form entry
   - Try uploading a resume
   - Check template selection
   - Download PDF and DOCX

4. **Customize**
   - Edit templates in `server/latex_generator.py`
   - Modify UI components
   - Add custom fields

5. **Deploy**
   - Follow [DEPLOYMENT.md](DEPLOYMENT.md)
   - Set up CI/CD pipelines
   - Monitor production

## Support Resources

- **Frontend Issues**: Check [FRONTEND.md](client/FRONTEND.md)
- **Backend Issues**: Check [BACKEND.md](server/BACKEND.md)
- **API Questions**: Check [API.md](API.md)
- **Deployment Help**: Check [DEPLOYMENT.md](DEPLOYMENT.md)

## Performance Tips

- Install SSD for faster builds
- Use WSL2 on Windows for better performance
- Keep dependencies updated
- Monitor system resources during development

## Security Reminders

- Never commit `.env` files
- Keep API keys secret
- Use HTTPS in production
- Validate all file uploads
- Sanitize user input

---

**Installation Complete!** 🎉

Your Resume Builder is now ready for development. Start with the [QUICKSTART.md](QUICKSTART.md) guide.

For detailed information: See [README.md](README.md)
