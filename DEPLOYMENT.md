# Deployment Architecture

## Frontend: Vercel

### Deployment Steps
1. Push to GitHub
2. Import repo in Vercel Dashboard
3. Select "Next.js" framework
4. Set environment variable:
   ```
   NEXT_PUBLIC_API_URL=https://resume-builder-api.onrender.com
   ```
5. Deploy

### Performance
- CDN hosted globally
- Automatic SSL
- Serverless functions
- Analytics included

### URL Format
```
https://resume-builder.vercel.app
```

## Backend: Render

### Deployment Steps
1. Push to GitHub  
2. Create "New Web Service" in Render
3. Connect GitHub repo
4. Settings:
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn -w 4 -b 0.0.0.0:$PORT wsgi:app`
   - **Environment**:
     ```
     DEBUG=False
     CORS_ORIGINS=["https://resume-builder.vercel.app"]
     ```
5. Deploy

### Performance
- Free tier: 750 hours/month
- Paid: $7+/month (recommended)
- Auto-deploys on GitHub push
- Automatic SSL

### URL Format
```
https://resume-builder-api.onrender.com
```

## Environment Variables

### Frontend Production (Vercel)
```
NEXT_PUBLIC_API_URL=https://resume-builder-api.onrender.com
```

### Backend Production (Render)
```
DEBUG=False
ENABLE_ATS_API=False
CORS_ORIGINS=["https://resume-builder.vercel.app"]
```

## Database Plan (Future)

Optional: Add PostgreSQL for user accounts
- Store email, hashed passwords
- Save resume history
- Track ATS scores over time

## Monitoring

### Vercel
- Analytics: https://vercel.com/dashboard
- Performance metrics included
- Deployment logs

### Render
- Logs: `https://dashboard.render.com/#`
- Monitor CPU/Memory
- API response times

## Scaling Strategy

### Traffic Increase
- **Frontend**: Vercel auto-scales
- **Backend**: Upgrade Render tier

### Database Growth
- Set up PostgreSQL on Render
- Add caching layer (Redis)
- Implement pagination

## Security Checklist

- [ ] HTTPS enabled (automatic on both platforms)
- [ ] Environment variables configured
- [ ] CORS origins restricted
- [ ] Input validation on both sides
- [ ] File upload size limits
- [ ] Rate limiting (optional)
- [ ] SQL injection prevention

## Cost Estimation

| Service | Tier | Cost |
|---------|------|------|
| Vercel | Pro | $20/month |
| Render | Basic | Free → $7 |
| Total | | ~$27/month |

For high-traffic apps, consider:
- Vercel Pro: $20/month
- Render: $12+/month (1GB RAM, 0.5 CPU)
- PostgreSQL: $15/month

## CI/CD Pipeline

Automatic on both platforms:
1. Push to GitHub
2. GitHub Actions run tests (optional)
3. Vercel builds frontend
4. Render builds backend
5. Deployed to production

## Rollback Procedure

### Vercel
- Dashboard → Deployments
- Find previous version
- Click "Redeploy"

### Render
- Dashboard → Redeployments
- Select previous version
- Click redeploy

## Monitoring & Alerts

### Vercel
- Set up email alerts for failures
- Monitor usage in analytics

### Render
- Enable email notifications
- Monitor logs for errors

## Update Process

1. Make changes locally
2. Test thoroughly
3. Commit and push to GitHub
4. Vercel/Render auto-deploy
5. Verify in production

---

For detailed setup: See README.md Deployment section
