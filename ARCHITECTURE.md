# Architecture & System Design

## System Architecture Overview

```
┌─────────────────────────────────────────────────────────────┐
│                      CLIENT LAYER (Vercel)                  │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  Next.js Frontend (React + TypeScript)              │  │
│  │  ├─ Page: Home (/page.tsx)                          │  │
│  │  ├─ Components:                                      │  │
│  │  │  ├─ UploadResume.tsx (drag-drop)                │  │
│  │  │  ├─ ManualForm.tsx (form entries)               │  │
│  │  │  ├─ ATSScoreDisplay.tsx (results)               │  │
│  │  │  ├─ TemplateSelector.tsx (template pick)        │  │
│  │  │  └─ PreviewPanel.tsx (preview & download)       │  │
│  │  └─ Utils: axios client, env config                │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │  HTTP(S)
                            │  REST API
                            ▼
┌─────────────────────────────────────────────────────────────┐
│                    API LAYER (Render)                       │
│  ┌──────────────────────────────────────────────────────┐  │
│  │  FastAPI Backend (Python ASGI)                      │  │
│  │  ┌─────────────────────────────────────────────┐    │  │
│  │  │ Routes:                                     │    │  │
│  │  │ POST /api/resume/parse                      │    │  │
│  │  │ POST /api/ats/calculate                     │    │  │
│  │  │ POST /api/resume/generate/pdf               │    │  │
│  │  │ POST /api/resume/generate/docx              │    │  │
│  │  │ GET  /api/templates                         │    │  │
│  │  │ GET  /api/ats-keywords                      │    │  │
│  │  │ GET  /health                                │    │  │
│  │  └─────────────────────────────────────────────┘    │  │
│  └──────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                            │
        ┌───────────────────┼───────────────────┐
        │                   │                   │
        ▼                   ▼                   ▼
    ┌────────┐      ┌─────────────┐      ┌──────────┐
    │ Resume │      │    ATS      │      │  LaTeX  │
    │ Parser │      │  Scorer     │      │Generator │
    │        │      │             │      │          │
    │ • PDF  │      │ • Keywords  │      │ • AutoCV │
    │ • DOCX │      │ • Scoring   │      │ • Modern │
    │ • Ext  │      │ • Suggest   │      │ • Minimal│
    │        │      │             │      │ • Exec   │
    └────────┘      └─────────────┘      └──────────┘
                                               │
                                               ├─ pdflatex
                                               └─ python-docx
                                                   │
                                                   ▼
                                            ┌─────────────┐
                                            │    PDF &    │
                                            │    DOCX     │
                                            │   Files     │
                                            └─────────────┘
```

## Data Flow Diagram

```
USER UPLOADS RESUME
        │
        ▼
File Validation
├─ Format check (PDF/DOCX)
├─ Size check (<10MB)
└─ Content-Type validation
        │
        ▼
Resume Parser
├─ Extract text from file
├─ Identify sections (edu, exp, skills)
├─ Extract contact info
└─ Structure data
        │
        ▼
Structured Resume Data
{
  personalInfo: {...},
  education: [...],
  experience: [...],
  skills: [...],
  certifications: [...],
  projects: [...]
}
        │
        ├──────────────────┬──────────────────┐
        │                  │                  │
        ▼                  ▼                  ▼
   Display on      Calculate ATS      Select Template
   Frontend Form    Score
        │
        ├─ Keyword matching
        ├─ Section scoring
        ├─ Gap analysis
        └─ Suggestions
        │
        ▼
    Show Results
    • ATS Score (0-100)
    • Grade (A-F)
    • Suggestions
    • Keyword analysis
        │
        ▼
User Selects Template
        │
        ├─ AutoCV
        ├─ Modern
        ├─ Minimal
        └─ Executive
        │
        ▼
Generate Output
    ┌─ PDF Path ─→ Render LaTeX ─→ Compile ─→ Generate PDF
    │
    └─ DOCX Path ─→ Create Document ─→ Add Sections ─→ Generate DOCX
        │
        ▼
    Download File
```

## Component Hierarchy

### Frontend Components
```
App (page.tsx)
├── Header (Layout)
├── Tab Navigation
    ├── UploadResume
    │   └── Dropzone
    └── ManualForm
        ├── PersonalInfo Section
        ├── Education Section
        ├── Experience Section
        ├── Skills Section
        ├── Certifications Section
        └── Projects Section
├── Main Content Area
    └── TemplateSelector
        ├── Template Cards
        └── Selection Radio
└── Sidebar
    └── ATSScoreDisplay
        ├── Score Circle
        ├── Grade Badge
        ├── Suggestions List
        └── Keyword Analysis
└── PreviewPanel
    ├── Resume Preview
    ├── PDF Download Button
    └── DOCX Download Button
```

### Backend Modules
```
FastAPI App (main.py)
├── Routes
│   ├── POST /api/resume/parse
│   ├── POST /api/ats/calculate
│   ├── POST /api/resume/generate/pdf
│   ├── POST /api/resume/generate/docx
│   ├── GET /api/templates
│   ├── GET /api/ats-keywords
│   └── GET /health
├── Middleware
│   └── CORS
└── Services
    ├── ResumeParser (resume_parser.py)
    │   ├── parse_file()
    │   ├── _parse_pdf()
    │   ├── _parse_docx()
    │   ├── _extract_data()
    │   ├── _extract_email()
    │   ├── _extract_phone()
    │   └── _extract_sections()
    ├── ATSScorer (ats_scorer.py)
    │   ├── calculate_score()
    │   ├── _calculate_keyword_score()
    │   ├── _get_ats_suggestions()
    │   └── _calculate_grade()
    ├── LatexGenerator (latex_generator.py)
    │   ├── generate_latex()
    │   ├── latex_to_pdf()
    │   └── TEMPLATES
    └── DocxGenerator (docx_generator.py)
        ├── generate_docx()
        ├── _add_header()
        ├── _add_section()
        ├── _add_experience_section()
        └── _add_skills_section()
```

## Database Schema (Optional - Future)

For storing user accounts and resume history:

```sql
-- Users Table
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Resumes Table
CREATE TABLE resumes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    data JSON NOT NULL,
    ats_score DECIMAL(3,1),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- ATS Score History
CREATE TABLE ats_history (
    id INT PRIMARY KEY AUTO_INCREMENT,
    resume_id INT NOT NULL,
    score DECIMAL(3,1),
    grade CHAR(1),
    timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resume_id) REFERENCES resumes(id)
);
```

## Deployment Architecture

```
┌────────────────────────────────────────┐
│  GitHub Repository                     │
│  (Source Code & CI/CD Config)          │
└─────────┬──────────────────────────────┘
          │ Push to main
          │
          ├─────────────────────┬─────────────────────┐
          │                     │                     │
          ▼                     ▼                     ▼
    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
    │ GitHub       │    │ Vercel CI/CD │    │ Render CI/CD │
    │ Actions      │    │              │    │              │
    │              │    │ Build Next.js│    │ Build Python │
    │ • Lint       │    │ Run tests    │    │ Run tests    │
    │ • Test       │    │ Deploy to    │    │ Deploy to    │
    │ • Build      │    │ Vercel CDN   │    │ Render Env   │
    └──────────────┘    └──────────────┘    └──────────────┘
                             │                     │
                             ▼                     ▼
                    ┌──────────────────┐ ┌──────────────────┐
                    │ Vercel          │ │ Render           │
                    │                  │ │                  │
                    │ Frontend:        │ │ Backend:         │
                    │ resume-builder   │ │ resume-api       │
                    │ .vercel.app      │ │ .onrender.com    │
                    │                  │ │                  │
                    │ • Global CDN     │ │ • Python runtime │
                    │ • Auto-scale     │ │ • PostgreSQL opt │
                    │ • SSL included   │ │ • Health checks  │
                    │ • Analytics      │ │ • Auto-restart   │
                    └──────────────────┘ └──────────────────┘
                             │                     │
                             └──────────┬──────────┘
                                        │
                                        ▼
                            ┌─────────────────────┐
                            │  Users Access      │
                            │ Application via    │
                            │ resume-builder     │
                            │ .vercel.app        │
                            └─────────────────────┘
```

## File Processing Flow

```
FILE RECEIVED (PDF or DOCX)
        │
        ├─ Validation Check
        │  ├─ File size limit (10MB)
        │  ├─ Content-Type check
        │  └─ Extension check
        │
        ├─ If PDF
        │  └─ PyPDF2.PdfReader → extract_text()
        │
        ├─ If DOCX
        │  └─ python-docx.Document → iterate paragraphs
        │
        ├─ Text Processing
        │  ├─ Email extraction (regex)
        │  ├─ Phone extraction (regex)
        │  ├─ Section detection (keywords)
        │  ├─ Skill extraction (bullet parsing)
        │  └─ Experience parsing (date ranges)
        │
        └─ Output: Structured JSON
           {
             personalInfo: {...},
             education: [...],
             experience: [...],
             skills: [...],
             certifications: [...],
             projects: [...]
           }
```

## ATS Scoring Algorithm

```
RESUME DATA INPUT
        │
        ├─ Contact Information (15 pts)
        │  ├─ Email present (5 pts)
        │  ├─ Phone present (5 pts)
        │  └─ Location present (5 pts)
        │
        ├─ Professional Summary (10 pts)
        │  └─ Summary length > 50 chars
        │
        ├─ Education (15 pts)
        │  └─ Per education entry (3-7 pts)
        │
        ├─ Work Experience (20 pts)
        │  ├─ Company info (5 pts per entry)
        │  └─ Description present (5 pts per entry)
        │
        ├─ Skills (20 pts)
        │  └─ 2 points per skill (max 20)
        │
        ├─ Keyword Matching (15 pts)
        │  ├─ Match against database
        │  └─ 1 point per match (max 15)
        │
        ├─ Certifications (5 pts)
        │  └─ 2 points per cert (max 5)
        │
        └─ Projects (5 pts)
           └─ 2 points per project (max 5)

TOTAL SCORE: 0-100
    │
    ├─ 90-100: Grade A ✓
    ├─ 80-89:  Grade B ✓
    ├─ 70-79:  Grade C ⚠
    ├─ 60-69:  Grade D ⚠
    └─ <60:    Grade F ✗
```

## Performance Considerations

### Frontend
- **Optimization**: Next.js automatic code splitting
- **Caching**: Browser cache for assets
- **Performance**: Target <3s initial load

### Backend
- **Parsing Time**: 1-2 seconds (PDF extraction)
- **Scoring Time**: <100ms (algorithm speed)
- **PDF Generation**: 3-5 seconds (pdflatex)
- **DOCX Generation**: <500ms (in-memory)

### Database (if added)
- Implement indexes on user_id, email
- Cache frequently accessed templates
- Archive old resume data

## Security Layers

```
┌─ Client (Browser)
│  ├─ Input validation
│  ├─ File type check
│  └─ Size limit check
│
├─ Network
│  ├─ HTTPS/TLS encryption
│  └─ CORS restriction
│
├─ Server (FastAPI)
│  ├─ Request validation (Pydantic)
│  ├─ File upload validation
│  │  ├─ Size limit (10MB)
│  │  ├─ Format check
│  │  └─ Content scan
│  ├─ Rate limiting (future)
│  ├─ Input sanitization
│  └─ Error handling
│
└─ Data
   ├─ Temporary file cleanup
   ├─ No persistent storage
   └─ No sensitive data logging
```

## Scalability Strategy

```
GROWTH PHASE 1: Current Setup
- Single Vercel deployment
- Single Render deployment
- No database

PHASE 2 (when traffic increases)
├─ Add Redis cache
├─ Add PostgreSQL database
├─ Implement user accounts
└─ User data persistence

PHASE 3 (high volume)
├─ Load balancer
├─ Database replication
├─ CDN optimization
├─ Async job processing (Celery)
└─ Monitoring & alerting
```

## Monitoring & Logging Strategy

```
Frontend (Vercel)
├─ Performance Analytics
├─ Error tracking (optional: Sentry)
├─ User analytics (optional: Segment)
└─ Deployment logs

Backend (Render)
├─ Request/response logging
├─ Error logging
├─ Performance metrics
├─ Resource usage (CPU/Memory)
└─ Health check monitoring
```

---

**Architecture Version**: 1.0
**Last Updated**: February 18, 2026
