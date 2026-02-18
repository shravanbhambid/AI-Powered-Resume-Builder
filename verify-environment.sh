#!/bin/bash
# Resume Builder - Environment Verification Script
# Run this script to verify your development environment is properly configured

echo "=========================================="
echo "Resume Builder - Environment Checker"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Counter for checks
PASS=0
FAIL=0

# Function to check command existence
check_command() {
    if command -v "$1" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $1 is installed"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $1 is NOT installed"
        ((FAIL++))
        return 1
    fi
}

# Function to check file/directory
check_file() {
    if [ -e "$1" ]; then
        echo -e "${GREEN}✓${NC} $1 exists"
        ((PASS++))
        return 0
    else
        echo -e "${RED}✗${NC} $1 NOT found"
        ((FAIL++))
        return 1
    fi
}

echo "1. Checking System Requirements..."
echo "-----------------------------------"
check_command node
check_command python
check_command pip
check_command git
check_command pdflatex
echo ""

echo "2. Checking Project Structure..."
echo "-----------------------------------"
check_file "client/"
check_file "server/"
check_file "README.md"
check_file "package.json"
echo ""

echo "3. Checking Frontend Setup..."
echo "-----------------------------------"
if [ -d "client/" ]; then
    cd client
    check_file "package.json"
    check_file ".env.example"
    check_file "next.config.js"
    
    if [ -d "node_modules" ]; then
        echo -e "${GREEN}✓${NC} node_modules installed"
        ((PASS++))
    else
        echo -e "${YELLOW}⚠${NC} node_modules not installed (run: npm install)"
        ((FAIL++))
    fi
    cd ..
fi
echo ""

echo "4. Checking Backend Setup..."
echo "-----------------------------------"
if [ -d "server/" ]; then
    cd server
    check_file "main.py"
    check_file "requirements.txt"
    check_file ".env.example"
    
    # Check virtual environment
    if [ -d "venv" ]; then
        echo -e "${GREEN}✓${NC} Virtual environment exists"
        ((PASS++))
        
        # Check if key packages are installed
        if [ -f "venv/bin/python" ] || [ -f "venv/Scripts/python.exe" ]; then
            echo -e "${GREEN}✓${NC} Python venv accessible"
            ((PASS++))
        fi
    else
        echo -e "${YELLOW}⚠${NC} Virtual environment not found (run: python -m venv venv)"
        ((FAIL++))
    fi
    
    cd ..
fi
echo ""

echo "5. Checking Environment Variables..."
echo "-----------------------------------"
if [ -f "client/.env.local" ]; then
    echo -e "${GREEN}✓${NC} Frontend .env.local exists"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} Frontend .env.local not found (see .env.example)"
    ((FAIL++))
fi

if [ -f "server/.env" ]; then
    echo -e "${GREEN}✓${NC} Backend .env exists"
    ((PASS++))
else
    echo -e "${YELLOW}⚠${NC} Backend .env not found (see .env.example)"
    ((FAIL++))
fi
echo ""

echo "6. Version Information..."
echo "-----------------------------------"
node --version 2>/dev/null && echo "  Node.js version OK" || echo -e "${RED}  Node.js not found${NC}"
python --version 2>/dev/null && echo "  Python version OK" || echo -e "${RED}  Python not found${NC}"
npm --version 2>/dev/null && echo "  npm version OK" || echo -e "${RED}  npm not found${NC}"
pdflatex --version 2>/dev/null | head -1 && echo "  LaTeX version OK" || echo -e "${RED}  pdflatex not found${NC}"
echo ""

echo "=========================================="
echo "Summary"
echo "=========================================="
echo -e "Passed: ${GREEN}$PASS${NC}"
echo -e "Failed: ${RED}$FAIL${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ All checks passed! You're ready to develop.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. cd server && python main.py"
    echo "2. cd client && npm run dev (in another terminal)"
    echo "3. Open http://localhost:3000"
else
    echo -e "${RED}✗ Some checks failed. See above for details.${NC}"
    echo ""
    echo "Common fixes:"
    echo "1. Install Node.js: https://nodejs.org/"
    echo "2. Install Python: https://python.org/"
    echo "3. Install pdflatex (MiKTeX/TeX Live)"
    echo "4. Run: npm install (in client folder)"
    echo "5. Run: pip install -r requirements.txt (in server venv)"
fi
