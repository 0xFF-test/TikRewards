# TikRewards

A Next.js web platform where users earn points by watching embedded TikTok videos, liking them, and leaving comments. The system targets early discovery and feedback for creators while remaining compliant with TikTok policies.

## 🎯 Overview

This platform allows:
- **Viewers** to earn points by watching TikTok videos and engaging with content
- **Creators** to submit their TikTok videos to gain early visibility
- Real, organic engagement without automation or policy violations

## ✨ Features

### Phase 1 (Current - MVP)
- ✅ Email-based authentication
- ✅ User onboarding flow
- ✅ Video watching with timer-based completion tracking
- ✅ Points system with completion multipliers
- ✅ Free video submissions (2 lifetime slots)
- ✅ Abandonment penalty system
- ✅ Cooldown system with follow incentives
- ✅ Basic creator submission interface

### Phase 2 (Upcoming)
- 🔜 Payment integration for video credits
- 🔜 Stripe/PayPal integration
- 🔜 Credit purchase system with bulk discounts

### Phase 3 (Planned)
- 📋 Account promotion feature
- 📋 Promoted follow campaigns
- 📋 Advanced cooldown management

### Phase 4 (Future)
- 📋 Admin moderation panel
- 📋 Analytics dashboard for creators
- 📋 Reputation scoring system

## 🏗️ Tech Stack

- **Frontend**: Next.js 14, React, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes
- **Database**: Supabase (PostgreSQL)
- **Authentication**: JWT with email login
- **Hosting**: Vercel (recommended)

## 📋 Prerequisites

- Node.js 18+ installed
- npm or yarn
- Supabase account
- Git

## 🚀 Setup Instructions

### 1. Clone the Repository

```bash
cd tikrewards
npm install
```

### 2. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the schema from `supabase-schema.sql`
3. Get your project URL and keys from Settings > API

### 3. Configure Environment Variables

Copy `.env.example` to `.env.local`:

```bash
cp .env.example .env.local
```

Update the following variables:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_project_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key
JWT_SECRET=your_secure_random_string
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### 4. Run the Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## 📊 Database Schema

### Core Tables

- **users**: User accounts with points and onboarding status
- **videos**: Submitted TikTok videos in the queue
- **view_logs**: Tracking of video views and engagement
- **points_logs**: Complete audit log of all point transactions
- **abandonment_logs**: Tracking of video abandonments
- **follow_tracking**: Tracks which accounts users have followed
- **promoted_accounts**: Accounts being promoted for follows
- **user_sessions**: Video locking for concurrent viewing

## 🎮 How It Works

### For Viewers

1. **Sign Up**: Enter your email to create an account
2. **Onboard**: Follow @0xFinanceFirst and watch 2 videos
3. **Watch Videos**: 
   - Videos must be watched for their full duration (90% threshold)
   - 15-second minimum overlay prevents skipping
   - Click "Like" to open TikTok and like the video
   - Click "Comment" to open TikTok and comment (unlocks after like)
4. **Earn Points**:
   - Watch complete: 10 points
   - Like clicked: +5 points
   - Comment clicked: +10 points
   - All three completed: 1.5x multiplier = 38 total points
5. **Cooldown**: After 10 videos, follow promoted accounts to reduce cooldown

### For Creators

1. **Earn Points**: Watch videos to build your point balance
2. **Submit Videos**:
   - **Free Submission**: Requires 3,800 points, 30-minute wait, 2 lifetime slots
   - **Paid Submission**: $1 per video, instant activation, highest priority
3. **Get Views**: Your video enters the queue and gets shown to engaged viewers

## 🎯 Points System

### Earning Points

| Action | Points | Notes |
|--------|--------|-------|
| Watch video (90%+) | 10 | Base points |
| Like clicked | 5 | Opens TikTok |
| Comment clicked | 10 | Opens TikTok |
| **All 3 completed** | **38** | **1.5x multiplier** |

### Spending Points

- Free video submission: 3,800 points (100 perfect videos)

### Penalties

| Abandonment Count | Penalty |
|------------------|---------|
| 1st | -15 points |
| 2nd (consecutive) | -30 points |
| 3rd (consecutive) | -60 points |
| 4th+ (consecutive) | -120 points |

Points cannot go below 0.

## 🛡️ Compliance & Safety

### TikTok Policy Compliance

- ✅ No automation or bots
- ✅ All engagement is manual and performed by real users
- ✅ No credential sharing or TikTok account linking
- ✅ No guaranteed views or engagement
- ✅ Respects TikTok embed terms
- ✅ Clear disclaimers on all pages

### Abuse Prevention

- Rate limiting per IP and account
- Session tracking and timeouts
- Duplicate view detection
- Cooldown timers
- Video validation (15s - 3min length)
- One submission per video (prevents spam)

## 💰 Monetization (Phase 2)

### Video Credits

- **Single**: $1.00 per video
- **5-pack**: $4.50 (-10% discount)
- **10-pack**: $7.50 (-25% discount)
- **20-pack**: $10.00 (-50% discount)

### Account Promotion (Phase 3)

- 6-hour promotion slot: $3.00
- Users follow promoted accounts for cooldown reduction
- Separate credit pool from video credits

## 🏗️ Project Structure

```
tikrewards/
├── app/
│   ├── api/
│   │   ├── auth/login/          # Authentication endpoint
│   │   ├── videos/
│   │   │   ├── submit/          # Video submission
│   │   │   ├── next/            # Get next video
│   │   │   └── view/            # Complete video view
│   │   ├── actions/
│   │   │   ├── like/            # Track like action
│   │   │   ├── comment/         # Track comment action
│   │   │   └── follow/          # Track follow action
│   │   └── users/points/        # Get user points
│   ├── viewer/
│   │   ├── onboarding/          # Onboarding flow
│   │   └── page.tsx             # Main viewer dashboard
│   ├── creator/
│   │   └── page.tsx             # Creator submission page
│   ├── page.tsx                 # Homepage / Login
│   ├── layout.tsx               # Root layout
│   └── globals.css              # Global styles
├── lib/
│   ├── supabase.ts              # Supabase client
│   ├── auth.ts                  # Auth middleware
│   ├── constants.ts             # App constants
│   └── types.ts                 # TypeScript types
├── supabase-schema.sql          # Database schema
└── README.md
```

## 🔧 API Endpoints

### Authentication
- `POST /api/auth/login` - Email login/signup

### Videos
- `POST /api/videos/submit` - Submit a TikTok video
- `GET /api/videos/next` - Get next video in queue
- `POST /api/videos/view` - Complete video view

### Actions
- `POST /api/actions/like` - Track like action
- `POST /api/actions/comment` - Track comment action
- `POST /api/actions/follow` - Track follow action

### Users
- `GET /api/users/points` - Get current user points

## 🎨 Design Philosophy

The platform uses a dark, modern aesthetic with:
- Dark background (#0a0a0b)
- Primary color: Pink/Red (#e74c60)
- Glass morphism effects
- Smooth animations and transitions
- Mobile-first responsive design

## 🚢 Deployment

### Deploy to Vercel

1. Push your code to GitHub
2. Import project in Vercel
3. Add environment variables
4. Deploy!

### Environment Variables to Set

All variables from `.env.example` must be set in your deployment platform.

## 📝 Development Notes

### Testing Locally

1. Use different email addresses to create multiple test users
2. Test the full flow: signup → onboarding → watching → submission
3. Verify points calculations are correct
4. Test abandonment penalties
5. Test cooldown system

### Known Limitations

- TikTok embed API has limited player controls
- Video watch time is timer-based (not actual playback tracking)
- Payment integration not yet implemented (Phase 2)
- No actual TikTok video embedding (showing placeholders)

## 🤝 Contributing

This is a commercial project. For questions or support, please contact the project owner.

## 📄 License

Proprietary - All rights reserved

## 🆘 Support

For issues or questions:
1. Check the documentation above
2. Review the code comments
3. Check Supabase logs for database errors
4. Review browser console for frontend errors

## 🗺️ Roadmap

- [x] Phase 1: Core MVP with free submissions
- [ ] Phase 2: Payment integration
- [ ] Phase 3: Account promotion feature
- [ ] Phase 4: Admin panel
- [ ] Phase 5: Advanced analytics
- [ ] Phase 6: Mobile app

---

**Important**: This platform does not guarantee views or engagement. All engagement is organic and performed by real users. We do not use automation or violate TikTok's terms of service.
