# Resume Builder API Documentation

Complete REST API documentation for the Resume Builder backend.

## Base URL

- **Development**: `http://localhost:8000`
- **Production**: `https://resume-builder-api.onrender.com`

## Authentication

Currently, the API does not require authentication. Future versions will include OAuth.

## Response Format

All responses follow a consistent JSON format:

```json
{
  "success": true,
  "data": {},
  "message": "Description of response"
}
```

Errors:
```json
{
  "detail": "Error description"
}
```

## Endpoints

### 1. Health Check

**GET** `/health`

Simple health check endpoint.

**Response** (200 OK):
```json
{
  "status": "ok",
  "service": "Resume Builder API"
}
```

---

### 2. Parse Resume

**POST** `/api/resume/parse`

Parse uploaded resume file (PDF or DOCX) and extract structured data.

**Request:**
```
Content-Type: multipart/form-data

Body:
  file: File (required) - PDF or DOCX file
```

**Response** (200 OK):
```json
{
  "success": true,
  "data": {
    "personalInfo": {
      "fullName": "John Doe",
      "email": "john@example.com",
      "phone": "(555) 123-4567",
      "location": "San Francisco, CA",
      "summary": "Experienced software engineer..."
    },
    "education": [
      {
        "school": "Stanford University",
        "degree": "B.S.",
        "field": "Computer Science",
        "graduationYear": "2020"
      }
    ],
    "experience": [
      {
        "company": "Tech Corp",
        "position": "Senior Engineer",
        "startDate": "2021",
        "endDate": "2024",
        "description": "Led team of 5 engineers..."
      }
    ],
    "skills": ["Python", "React", "AWS", "Docker"],
    "certifications": ["AWS Solutions Architect"],
    "projects": []
  },
  "message": "Resume parsed successfully"
}
```

**Error Responses:**

400 Bad Request:
```json
{
  "detail": "Invalid file format. Please upload PDF or DOCX file."
}
```

413 Payload Too Large:
```json
{
  "detail": "File too large. Maximum size: 10MB"
}
```

500 Server Error:
```json
{
  "detail": "Error parsing resume: [error details]"
}
```

---

### 3. Calculate ATS Score

**POST** `/api/ats/calculate`

Calculate ATS (Applicant Tracking System) compatibility score for resume data.

**Request:**
```json
{
  "resume_data": {
    "personalInfo": {
      "fullName": "John Doe",
      "email": "john@example.com",
      "phone": "(555) 123-4567",
      "location": "San Francisco, CA",
      "summary": "Experienced software engineer with 5+ years..."
    },
    "education": [
      {
        "school": "Stanford University",
        "degree": "B.S.",
        "field": "Computer Science",
        "graduationYear": "2020"
      }
    ],
    "experience": [
      {
        "company": "Tech Corp",
        "position": "Senior Engineer",
        "startDate": "2021",
        "endDate": "2024",
        "description": "Led development of microservices architecture..."
      }
    ],
    "skills": ["Python", "React", "AWS", "Docker", "Kubernetes"],
    "certifications": ["AWS Solutions Architect"],
    "projects": []
  }
}
```

**Response** (200 OK):
```json
{
  "success": true,
  "score": 85,
  "grade": "B",
  "suggestions": [
    "Add more specific technical skills",
    "Use action verbs in descriptions (e.g., Developed, Implemented)",
    "Include 2-3 more work experiences"
  ],
  "keyword_analysis": {
    "matched_keywords": [
      "Python",
      "React",
      "AWS",
      "Docker",
      "Kubernetes"
    ],
    "missing_keywords": [
      "REST API",
      "Git",
      "SQL",
      "MongoDB",
      "DevOps"
    ]
  },
  "message": "ATS score calculated successfully"
}
```

**Score Breakdown:**
- **90-100**: Grade A (Excellent)
- **80-89**: Grade B (Good)
- **70-79**: Grade C (Fair)
- **60-69**: Grade D (Poor)
- **Below 60**: Grade F (Critical)

**Scoring Components:**
- Contact Information: 15 points
- Professional Summary: 10 points
- Education: 15 points
- Work Experience: 20 points
- Skills: 20 points
- Keyword Matching: 15 points
- Certifications: 5 points

---

### 4. Generate PDF

**POST** `/api/resume/generate/pdf`

Generate formatted PDF from resume data using LaTeX templates.

**Request:**
```json
{
  "resume_data": {
    "personalInfo": {"fullName": "John Doe", ...},
    "education": [...],
    "experience": [...],
    "skills": [...],
    "certifications": [...],
    "projects": [...]
  },
  "template": "autocv"
}
```

**Template Options:**
- `autocv` (default) - Clean professional with sidebar
- `modern` - Contemporary with accent colors
- `minimal` - Simple and elegant
- `executive` - Senior role focused

**Response** (200 OK):
```
Content-Type: application/pdf
Content-Disposition: attachment; filename=resume.pdf

[Binary PDF data]
```

**Error Response:**
```json
{
  "detail": "Error generating PDF: pdflatex not found"
}
```

---

### 5. Generate DOCX

**POST** `/api/resume/generate/docx`

Generate formatted Word document (.docx) from resume data.

**Request:**
```json
{
  "resume_data": {
    "personalInfo": {"fullName": "John Doe", ...},
    "education": [...],
    "experience": [...],
    "skills": [...],
    "certifications": [...],
    "projects": [...]
  },
  "template": "autocv"
}
```

**Note:** Template parameter is currently for future use. DOCX uses standard formatting.

**Response** (200 OK):
```
Content-Type: application/vnd.openxmlformats-officedocument.wordprocessingml.document
Content-Disposition: attachment; filename=resume.docx

[Binary DOCX data]
```

---

### 6. Get Available Templates

**GET** `/api/templates`

Get list of available resume templates.

**Response** (200 OK):
```json
{
  "templates": [
    {
      "id": "autocv",
      "name": "AutoCV",
      "description": "Clean and professional template with left sidebar"
    },
    {
      "id": "modern",
      "name": "Modern",
      "description": "Contemporary design with accent colors"
    },
    {
      "id": "minimal",
      "name": "Minimal",
      "description": "Simple and elegant minimalist template"
    },
    {
      "id": "executive",
      "name": "Executive",
      "description": "Professional template for senior roles"
    }
  ]
}
```

---

### 7. Get ATS Keywords

**GET** `/api/ats-keywords`

Get database of common ATS keywords.

**Response** (200 OK):
```json
{
  "keywords": [
    "Python",
    "JavaScript",
    "React",
    "AWS",
    "Docker",
    ...
  ],
  "total": 45
}
```

---

### 8. Get API Info

**GET** `/`

Get API information and available endpoints.

**Response** (200 OK):
```json
{
  "name": "Resume Builder API",
  "version": "1.0.0",
  "description": "FastAPI backend for Resume Builder",
  "endpoints": {
    "health": "/health",
    "parse": "/api/resume/parse",
    "ats": "/api/ats/calculate",
    "pdf": "/api/resume/generate/pdf",
    "docx": "/api/resume/generate/docx",
    "templates": "/api/templates",
    "keywords": "/api/ats-keywords"
  }
}
```

---

## Request/Response Models

### PersonalInfo
```typescript
{
  fullName: string;
  email: string;
  phone?: string;
  location?: string;
  summary?: string;
}
```

### Education
```typescript
{
  school: string;
  degree: string;
  field?: string;
  graduationYear?: string;
}
```

### WorkExperience
```typescript
{
  company: string;
  position: string;
  startDate?: string;
  endDate?: string;
  description?: string;
}
```

### Project
```typescript
{
  title: string;
  description?: string;
  technologies?: string;
}
```

### ResumeData
```typescript
{
  personalInfo: PersonalInfo;
  education: Education[];
  experience: WorkExperience[];
  skills: string[];
  certifications: string[];
  projects: Project[];
}
```

---

## Error Codes

| Code | Name | Description |
|------|------|-------------|
| 200 | OK | Request successful |
| 400 | Bad Request | Invalid file format or request |
| 413 | Payload Too Large | File exceeds size limit (10MB) |
| 500 | Internal Server Error | Server error |

---

## Rate Limiting

Currently no rate limiting implemented. Future versions will include:
- 100 requests per minute per IP
- 1000 requests per day per API key

---

## CORS

Cross-Origin Resource Sharing is enabled for:
- `http://localhost:3000` (development)
- `https://yourdomain.vercel.app` (production)

Configure in `.env`:
```
CORS_ORIGINS=["http://localhost:3000"]
```

---

## File Upload Specifications

### Supported Formats
- **PDF**: `.pdf` files
- **DOCX**: `.docx` files

### Maximum Size
- 10 MB per file

### Content Type Headers
- PDF: `application/pdf`
- DOCX: `application/vnd.openxmlformats-officedocument.wordprocessingml.document`

---

## Example Usage

### cURL

Parse resumehave
```bash
curl -X POST http://localhost:8000/api/resume/parse \
  -F "file=@resume.pdf"
```

Calculate ATS score:
```bash
curl -X POST http://localhost:8000/api/ats/calculate \
  -H "Content-Type: application/json" \
  -d '{
    "resume_data": {
      "personalInfo": {"fullName": "John Doe", "email": "john@example.com"},
      "skills": ["Python", "React"]
    }
  }'
```

Generate PDF:
```bash
curl -X POST http://localhost:8000/api/resume/generate/pdf \
  -H "Content-Type: application/json" \
  -d '{
    "resume_data": {...},
    "template": "autocv"
  }' \
  --output resume.pdf
```

### JavaScript/Fetch

```javascript
// Parse resume
const formData = new FormData();
formData.append('file', document.getElementById('resumeFile').files[0]);

const parseResponse = await fetch('/api/resume/parse', {
  method: 'POST',
  body: formData
});

const parseData = await parseResponse.json();

// Calculate ATS
const atsResponse = await fetch('/api/ats/calculate', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    resume_data: parseData.data
  })
});

const atsData = await atsResponse.json();
console.log(`ATS Score: ${atsData.score}`);
```

### Python/Requests

```python
import requests

# Parse resume
files = {'file': open('resume.pdf', 'rb')}
response = requests.post('http://localhost:8000/api/resume/parse', files=files)
resume_data = response.json()['data']

# Calculate ATS
ats_response = requests.post(
    'http://localhost:8000/api/ats/calculate',
    json={'resume_data': resume_data}
)
print(f"ATS Score: {ats_response.json()['score']}")

# Generate PDF
pdf_response = requests.post(
    'http://localhost:8000/api/resume/generate/pdf',
    json={
        'resume_data': resume_data,
        'template': 'autocv'
    }
)
with open('resume_output.pdf', 'wb') as f:
    f.write(pdf_response.content)
```

---

## Troubleshooting

### PDF Generation Fails
```
Error: Error generating PDF: pdflatex not found
```
**Solution**: Install LaTeX distribution (MiKTeX, TeX Live, or Texlive)

### File Upload Error
```
Error: File too large. Maximum size: 10MB
```
**Solution**: Ensure your resume file is under 10MB

### CORS Error
```
Access to XMLHttpRequest blocked by CORS policy
```
**Solution**: Add frontend URL to `CORS_ORIGINS` in `.env`

---

## Deployment Endpoints

### Vercel Frontend
```
https://your-app.vercel.app
```

### Render Backend
```
https://your-api.onrender.com
```

---

## Further Documentation

- [Frontend Guide](../client/FRONTEND.md)
- [Backend Guide](../server/BACKEND.md)
- [Deployment Guide](../DEPLOYMENT.md)
- [Quick Start](../QUICKSTART.md)

---

**Last Updated**: February 18, 2026
**API Version**: 1.0.0
