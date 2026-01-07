# Deployment Guide

## Prerequisites

- GitHub account
- Vercel account (free tier works)
- Supabase account (free tier works)
- Domain name (optional)

## Step-by-Step Deployment

### 1. Prepare Supabase

#### Create Project
1. Go to [supabase.com](https://supabase.com)
2. Click "New Project"
3. Choose organization and fill in:
   - Name: `tikrewards`
   - Database Password: (generate a strong password)
   - Region: Choose closest to your users

#### Run Database Schema
1. Wait for project to finish setting up (~2 minutes)
2. Go to SQL Editor
3. Create a new query
4. Copy entire contents of `supabase-schema.sql`
5. Paste and click "Run"
6. Verify all tables were created (check Table Editor)

#### Get API Keys
1. Go to Settings → API
2. Copy these values:
   - Project URL (e.g., `https://xxxxx.supabase.co`)
   - `anon` `public` key
   - `service_role` `secret` key (keep this secure!)

### 2. Prepare GitHub Repository

```bash
# Initialize git if not already done
git init

# Add all files
git add .

# Commit
git commit -m "Initial commit - TikRewards"

# Create GitHub repository (via GitHub website)
# Then add remote and push

git remote add origin https://github.com/yourusername/tikrewards.git
git branch -M main
git push -u origin main
```

### 3. Deploy to Vercel

#### Import Project
1. Go to [vercel.com](https://vercel.com)
2. Click "Add New..." → "Project"
3. Import your GitHub repository
4. Configure:
   - Framework Preset: Next.js
   - Root Directory: `./`
   - Build Command: `npm run build` (default)
   - Output Directory: `.next` (default)

#### Add Environment Variables

Click "Environment Variables" and add:

```env
NEXT_PUBLIC_SUPABASE_URL=https://xxxxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key_here
JWT_SECRET=generate_a_random_secure_string_here
NEXT_PUBLIC_APP_URL=https://your-app.vercel.app
NEXT_PUBLIC_TIKTOK_MAIN_ACCOUNT=@0xFinanceFirst
```

**Important**: 
- Use production values for all keys
- Generate a strong JWT_SECRET (e.g., use `openssl rand -base64 32`)
- Update `NEXT_PUBLIC_APP_URL` with your actual Vercel domain

#### Deploy

1. Click "Deploy"
2. Wait ~2-3 minutes for build
3. Your app will be live at `https://your-app.vercel.app`

### 4. Post-Deployment Setup

#### Test the Application

1. Visit your deployed URL
2. Test signup with a real email
3. Complete onboarding flow
4. Try watching a video (will show placeholder)
5. Try submitting a video
6. Verify points system works

#### Configure Custom Domain (Optional)

1. In Vercel, go to Settings → Domains
2. Add your custom domain
3. Follow DNS configuration instructions
4. Wait for DNS propagation (~10 minutes to 48 hours)
5. Update `NEXT_PUBLIC_APP_URL` environment variable

### 5. Production Checklist

Before going live:

- [ ] Database schema is deployed correctly
- [ ] All environment variables are set
- [ ] JWT_SECRET is secure and unique
- [ ] Test full user flow (signup → watch → submit)
- [ ] Points calculations are correct
- [ ] Abandonment penalties work
- [ ] Cooldown system functions
- [ ] Video submission validation works
- [ ] Test on mobile devices
- [ ] Set up error monitoring (Sentry, LogRocket, etc.)
- [ ] Configure analytics (Vercel Analytics, Google Analytics)
- [ ] Add legal pages (Terms of Service, Privacy Policy)
- [ ] Test payment integration (Phase 2)

## Monitoring & Maintenance

### Vercel Dashboard

Monitor:
- Deployment status
- Function logs
- Analytics
- Error tracking

### Supabase Dashboard

Monitor:
- Database usage
- API requests
- Storage
- Active connections

### Regular Checks

1. **Daily**:
   - Check error logs
   - Monitor user signups
   - Review video submissions

2. **Weekly**:
   - Database performance
   - Points economy balance
   - Abuse detection

3. **Monthly**:
   - Scale database if needed
   - Update dependencies
   - Review and optimize queries

## Scaling Considerations

### When to Scale

Signs you need to scale:
- Supabase free tier limits reached
- Vercel function timeouts
- Slow database queries
- High concurrent user load

### Scaling Options

1. **Database**:
   - Upgrade Supabase plan
   - Add database indexes
   - Implement caching (Redis)
   - Consider read replicas

2. **API**:
   - Optimize API routes
   - Implement rate limiting
   - Add CDN for static assets
   - Use Edge Functions

3. **Frontend**:
   - Implement lazy loading
   - Add service worker
   - Optimize images
   - Use ISR (Incremental Static Regeneration)

## Troubleshooting

### Common Issues

#### Build Fails
- Check `package.json` dependencies
- Verify TypeScript errors
- Review build logs in Vercel

#### Database Connection Errors
- Verify Supabase keys are correct
- Check if database is paused (free tier)
- Review Supabase logs

#### Authentication Issues
- Verify JWT_SECRET is set
- Check token expiration
- Review CORS settings

#### Points Not Updating
- Check database permissions
- Review API logs
- Verify point calculation logic

## Rollback Procedure

If deployment has critical issues:

1. In Vercel, go to Deployments
2. Find previous working deployment
3. Click "..." → "Promote to Production"
4. Fix issues in development
5. Redeploy when ready

## Security Best Practices

1. **Never commit secrets** to Git
2. Use **environment variables** for all sensitive data
3. Enable **Vercel's DDoS protection**
4. Implement **rate limiting** on API routes
5. Regular **security audits** of dependencies
6. Use **Supabase RLS** (Row Level Security) policies
7. Sanitize all user inputs
8. Validate all API requests

## Backup Strategy

### Database Backups

Supabase automatically backs up databases, but also:
1. Export schema regularly
2. Take manual snapshots before major changes
3. Export critical data monthly

### Code Backups

- Use Git (already done)
- Create release tags for major versions
- Document all significant changes

## Cost Estimation

### Free Tier (0-1000 users)
- Vercel: Free
- Supabase: Free
- **Total: $0/month**

### Paid Tier (1000-10000 users)
- Vercel Pro: ~$20/month
- Supabase Pro: ~$25/month
- **Total: ~$45/month**

### Scale (10000+ users)
- Vercel Enterprise: Custom pricing
- Supabase Team: ~$599/month
- CDN: ~$50/month
- **Total: Varies**

---

**Congratulations!** Your TikRewards platform is now deployed and ready for users!
