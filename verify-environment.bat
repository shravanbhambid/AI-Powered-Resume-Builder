@echo off
REM Resume Builder - Environment Verification Script for Windows
REM Run this batch file to verify your development environment is properly configured

setlocal enabledelayedexpansion

echo.
echo ==========================================
echo Resume Builder - Environment Checker
echo ==========================================
echo.

set PASS=0
set FAIL=0

REM Function to check command existence
echo 1. Checking System Requirements...
echo -----------------------------------

echo Checking Node.js...
node --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Node.js is installed
    set /a PASS+=1
) else (
    echo [FAIL] Node.js is NOT installed
    set /a FAIL+=1
)

echo Checking Python...
python --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Python is installed
    set /a PASS+=1
) else (
    echo [FAIL] Python is NOT installed
    set /a FAIL+=1
)

echo Checking npm...
npm --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] npm is installed
    set /a PASS+=1
) else (
    echo [FAIL] npm is NOT installed
    set /a FAIL+=1
)

echo Checking Git...
git --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] Git is installed
    set /a PASS+=1
) else (
    echo [FAIL] Git is NOT installed
    set /a FAIL+=1
)

echo Checking pdflatex...
pdflatex --version >nul 2>&1
if %errorlevel% equ 0 (
    echo [PASS] pdflatex is installed
    set /a PASS+=1
) else (
    echo [FAIL] pdflatex is NOT installed
    set /a FAIL+=1
)

echo.
echo 2. Checking Project Structure...
echo -----------------------------------

if exist "client\" (
    echo [PASS] client\ directory exists
    set /a PASS+=1
) else (
    echo [FAIL] client\ directory not found
    set /a FAIL+=1
)

if exist "server\" (
    echo [PASS] server\ directory exists
    set /a PASS+=1
) else (
    echo [FAIL] server\ directory not found
    set /a FAIL+=1
)

if exist "README.md" (
    echo [PASS] README.md exists
    set /a PASS+=1
) else (
    echo [FAIL] README.md not found
    set /a FAIL+=1
)

echo.
echo 3. Checking Frontend Setup...
echo -----------------------------------

if exist "client\package.json" (
    echo [PASS] client\package.json exists
    set /a PASS+=1
) else (
    echo [FAIL] client\package.json not found
    set /a FAIL+=1
)

if exist "client\.env.example" (
    echo [PASS] client\.env.example exists
    set /a PASS+=1
) else (
    echo [FAIL] client\.env.example not found
    set /a FAIL+=1
)

if exist "client\node_modules" (
    echo [PASS] client\node_modules installed
    set /a PASS+=1
) else (
    echo [WARN] client\node_modules not installed (run: npm install)
    set /a FAIL+=1
)

echo.
echo 4. Checking Backend Setup...
echo -----------------------------------

if exist "server\main.py" (
    echo [PASS] server\main.py exists
    set /a PASS+=1
) else (
    echo [FAIL] server\main.py not found
    set /a FAIL+=1
)

if exist "server\requirements.txt" (
    echo [PASS] server\requirements.txt exists
    set /a PASS+=1
) else (
    echo [FAIL] server\requirements.txt not found
    set /a FAIL+=1
)

if exist "server\.env.example" (
    echo [PASS] server\.env.example exists
    set /a PASS+=1
) else (
    echo [FAIL] server\.env.example not found
    set /a FAIL+=1
)

if exist "server\venv" (
    echo [PASS] Virtual environment exists
    set /a PASS+=1
) else (
    echo [WARN] Virtual environment not found (run: python -m venv venv)
    set /a FAIL+=1
)

echo.
echo 5. Checking Environment Variables...
echo -----------------------------------

if exist "client\.env.local" (
    echo [PASS] Frontend .env.local exists
    set /a PASS+=1
) else (
    echo [WARN] Frontend .env.local not found
    set /a FAIL+=1
)

if exist "server\.env" (
    echo [PASS] Backend .env exists
    set /a PASS+=1
) else (
    echo [WARN] Backend .env not found
    set /a FAIL+=1
)

echo.
echo ==========================================
echo Summary
echo ==========================================
echo Passed: %PASS%
echo Failed: %FAIL%
echo.

if %FAIL% equ 0 (
    echo [SUCCESS] All checks passed! You're ready to develop.
    echo.
    echo Next steps:
    echo 1. cd server ^&^& python main.py
    echo 2. cd client ^&^& npm run dev (in another terminal)
    echo 3. Open http://localhost:3000
) else (
    echo [WARNING] Some checks failed. See above for details.
    echo.
    echo Common fixes:
    echo 1. Install Node.js: https://nodejs.org/
    echo 2. Install Python: https://python.org/
    echo 3. Install MiKTeX: https://miktex.org/download
    echo 4. Run: npm install (in client folder)
    echo 5. Run: pip install -r requirements.txt (in server venv)
)

endlocal
