# Resume Builder - Full Stack Application

A comprehensive full-stack Resume Builder web application that allows users to create, optimize, and export ATS-friendly resumes.

## Features

### Core Functionality
- **Resume Upload & Parsing**: Upload PDF or DOCX files for automatic parsing
- **Manual Resume Entry**: Form-based resume creation with all standard sections
- **ATS Score Calculation**: Real-time ATS (Applicant Tracking System) scoring
- **Template Selection**: Choose from multiple ATS-friendly LaTeX templates
- **Multi-Format Export**: Download resumes as PDF or DOCX files
- **Improvement Suggestions**: Get actionable recommendations to improve ATS compatibility

### Frontend Features
- Modern, responsive UI built with Next.js and React
- Drag-and-drop file upload
- Real-time form validation
- Template preview
- One-click PDF/DOCX download
- Mobile-friendly design

### Backend Features
- FastAPI REST API
- Resume parsing (PDF/DOCX support)
- ATS scoring algorithm
- LaTeX compilation to PDF
- DOCX generation
- Environment variable management
- CORS support for frontend integration

## Tech Stack

### Frontend
- **Framework**: Next.js 14
- **Language**: TypeScript
- **Styling**: Tailwind CSS
- **State Management**: Zustand
- **File Upload**: react-dropzone
- **HTTP Client**: Axios
- **Word Generation**: docx

### Backend
- **Framework**: FastAPI (Python)
- **Server**: Uvicorn
- **Document Parsing**: PyPDF2, python-docx
- **Template Engine**: Jinja2
- **Export**: LaTeX (pdflatex), python-docx

## Project Structure

```
resume3/
├── client/                 # Next.js frontend
│   ├── app/               # App router  pages
│   ├── components/        # React components
│   ├── lib/              # Utility functions & API client
│   ├── package.json
│   ├── tsconfig.json
│   ├── tailwind.config.js
│   └── vercel.json       # Vercel deployment config
│
└── server/               # FastAPI backend
    ├── main.py          # FastAPI app & routes
    ├── config.py        # Configuration
    ├── models.py        # Data models
    ├── resume_parser.py # Resume parsing logic
    ├── ats_scorer.py    # ATS scoring algorithm
    ├── latex_generator.py # LaTeX to PDF conversion
    ├── docx_generator.py  # DOCX generation
    ├── ats_keywords.py   # ATS keyword database
    ├── requirements.txt
    ├── Procfile         # Render deployment config
    └── vercel.json      # Vercel deployment config
```

## Setup Instructions

### Prerequisites
- Node.js 18+ and npm
- Python 3.8+
- pdflatex (for PDF generation)
  - **Windows**: Install from MiKTeX
  - **macOS**: `brew install basictex`
  - **Linux**: `sudo apt-get install texlive-latex-base`

### Frontend Setup

1. Navigate to client directory:
```bash
cd client
```

2. Install dependencies:
```bash
npm install
```

3. Create `.env.local` file:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

4. Start development server:
```bash
npm run dev
```

Frontend will be available at http://localhost:3000

### Backend Setup

1. Navigate to server directory:
```bash
cd server
```

2. Create virtual environment:
```bash
python -m venv venv

# Windows
venv\Scripts\activate

# macOS/Linux
source venv/bin/activate
```

3. Install dependencies:
```bash
pip install -r requirements.txt
```

4. Create `.env` file:
```env
DEBUG=True
ATS_API_KEY=your_key_here
ENABLE_ATS_API=False
CORS_ORIGINS=["http://localhost:3000"]
```

5. Run development server:
```bash
python main.py
```

Backend will be available at http://localhost:8000

## API Endpoints

### Resume Parsing
- **POST** `/api/resume/parse` - Parse uploaded resume file
  - Request: multipart/form-data (file)
  - Response: Structured resume data

### ATS Scoring
- **POST** `/api/ats/calculate` - Calculate ATS score
  - Request: `{ "resume_data": {...} }`
  - Response: Score, grade, suggestions, keyword analysis

### Resume Generation
- **POST** `/api/resume/generate/pdf` - Generate PDF
  - Request: `{ "resume_data": {...}, "template": "autocv" }`
  - Response: PDF file

- **POST** `/api/resume/generate/docx` - Generate DOCX
  - Request: `{ "resume_data": {...}, "template": "autocv" }`
  - Response: DOCX file

### Utilities
- **GET** `/api/templates` - Get available templates
- **GET** `/api/ats-keywords` - Get ATS keywords database
- **GET** `/health` - Health check

## Available Templates

1. **AutoCV** - Clean professional template with sidebar
2. **Modern** - Contemporary design with accent colors
3. **Minimal** - Simple and elegant minimalist style
4. **Executive** - Professional layout for senior roles

## ATS Scoring Criteria

The ATS scoring algorithm evaluates:
- Contact information completeness (15 points)
- Professional summary (10 points)
- Education details (15 points)
- Work experience (20 points)
- Skills section (20 points)
- Keyword matching (15 points)
- Certifications (5 points)
- Projects (5 points)

**Total**: 100 points

### Grades
- A: 90-100
- B: 80-89
- C: 70-79
- D: 60-69
- F: Below 60

## Deployment

### Deploy Frontend to Vercel

1. Push code to GitHub
2. Import repository in Vercel Dashboard
3. Set environment variables:
   ```
   NEXT_PUBLIC_API_URL=https://your-backend-url.render.com
   ```
4. Deploy

### Deploy Backend to Render

1. Push code to GitHub
2. Create new Web Service in Render Dashboard
3. Select your repository
4. Set build command:
   ```
   pip install -r requirements.txt
   ```
5. Set start command:
   ```
   gunicorn -w 4 -b 0.0.0.0:$PORT wsgi:app
   ```
6. Add environment variables:
   ```
   DEBUG=False
   CORS_ORIGINS=["https://your-site.vercel.app"]
   ```
7. Deploy

### Environment Variables

**Frontend (.env.local)**
```
NEXT_PUBLIC_API_URL=https://your-backend-url
```

**Backend (.env)**
```
DEBUG=False
ATS_API_KEY=your_api_key
ENABLE_ATS_API=False
CORS_ORIGINS=["https://your-site.vercel.app"]
```

## Usage

1. Open application in browser
2. Choose to upload existing resume or enter details manually
3. Review extracted/entered information
4. Select preferred template
5. View ATS score and improvement suggestions
6. Download resume as PDF or DOCX

## Features Roadmap

- [ ] OAuth authentication
- [ ] User accounts and resume history
- [ ] Integration with job posting keywords
- [ ] Linkedin profile import
- [ ] Resume comparison tool
- [ ] Job application tracker
- [ ] AI-powered content suggestions
- [ ] Real time collaboration
- [ ] Additional template designs

## Common Issues

### PDF Generation Fails
- Ensure pdflatex is installed and in PATH
- **Windows**: Install MiKTeX and add to PATH
- **macOS**: Install with `brew install basictex`
- **Linux**: `sudo apt-get install texlive-latex-base`

### CORS Errors
- Verify CORS_ORIGINS includes frontend URL
- Check backend is running on correct port

### File Upload Issues
- Check maximum file size (10MB default)
- Ensure file format is PDF or DOCX

## License

MIT

## Support

For issues or feature requests, please create an issue in the repository.

## Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

![Image Alt](https://github.com/shravanbhambid/AI-Powered-Resume-Builder/blob/main/Screenshot%202026-02-18%20205952.png)

**Built with ❤️ for job seekers and professionals**

