# TikRewards 🎯

> **Earn points by watching TikTok videos, liking, and commenting. Submit your own content to get views from engaged users.**

A Next.js platform that incentivizes real engagement on TikTok content while helping creators gain early visibility. Built with compliance, quality, and user experience as top priorities.

---

## 🚀 Quick Start

### Try the Interactive Demo

Open `demo.html` in your browser to see the platform in action with simulated data!

### Deploy the Full App

1. **Set up Supabase**
   - Create account at [supabase.com](https://supabase.com)
   - Run `supabase-schema.sql` in SQL Editor
   - Copy your API keys

2. **Configure Environment**
   ```bash
   cp .env.example .env.local
   # Add your Supabase keys and JWT secret
   ```

3. **Install & Run**
   ```bash
   npm install
   npm run dev
   ```

4. **Deploy to Vercel**
   - See `DEPLOYMENT.md` for detailed steps

---

## ✨ Key Features

### For Viewers
- 🎬 Watch TikTok videos with timer-based completion tracking
- 💰 Earn points: 10 (watch) + 5 (like) + 10 (comment) = **38 points with 1.5x bonus**
- ⚡ Cooldown system: Follow accounts to reduce wait times
- 🎯 Free onboarding: Follow @0xFinanceFirst + watch 2 videos

### For Creators
- 📤 **Free submissions**: 3,800 points, 30-min wait, 2 lifetime slots
- 💳 **Paid submissions**: $1/video, instant activation, priority placement
- 📊 Track views, likes, and comments
- 🎁 Bulk discounts on credits (up to 50% off)

### Platform Features
- 🔒 JWT authentication with email login
- 🛡️ Abuse prevention: Exponential abandonment penalties (-15 to -120 pts)
- ✅ TikTok policy compliant (no automation, no bots)
- 📱 Fully responsive design
- 🎨 Modern dark UI with glassmorphism

---

## 📊 Points Economy

| Action | Points | Notes |
|--------|--------|-------|
| Watch (90%+ completion) | 10 | Base reward |
| Like (opens TikTok) | +5 | After watching |
| Comment (opens TikTok) | +10 | After liking |
| **All 3 completed** | **38** | **1.5x multiplier** |
| Video abandonment | -15 to -120 | Escalates with repeats |

**To submit free video**: 3,800 points ≈ 100 perfect completions

---

## 🏗️ Tech Stack

- **Frontend**: Next.js 14, React, TypeScript, Tailwind CSS
- **Backend**: Next.js API Routes (serverless)
- **Database**: Supabase (PostgreSQL)
- **Auth**: JWT with email login
- **Hosting**: Vercel (recommended)

---

## 📁 Project Structure

```
tikrewards/
├── app/
│   ├── api/              # Backend API routes
│   ├── viewer/           # Video watching interface
│   ├── creator/          # Video submission portal
│   └── page.tsx          # Login page
├── lib/
│   ├── supabase.ts       # Database client
│   ├── auth.ts           # JWT middleware
│   ├── constants.ts      # Configuration
│   └── types.ts          # TypeScript definitions
├── supabase-schema.sql   # Complete DB schema
├── demo.html             # Interactive frontend demo
├── README.md             # This file
├── DEPLOYMENT.md         # Deployment guide
└── API.md                # API documentation
```

---

## 🎮 How It Works

### Viewer Flow
1. Sign up with email
2. Complete onboarding (follow + watch 2 videos) → Earn 76 points
3. Watch videos with 15-second minimum overlay
4. Like and comment on TikTok (opens in new tab)
5. Earn 38 points for full completion
6. Repeat! Cooldowns apply after 10 videos

### Creator Flow
1. Earn 3,800 points by watching videos
2. Submit TikTok URL (free or paid)
3. Video enters queue based on payment status
4. Get shown to engaged viewers
5. Track your video's performance

---

## 💰 Monetization

### Video Credits (Phase 2 - Ready for Stripe)
- **1 video**: $1.00
- **5 videos**: $4.50 (-10%)
- **10 videos**: $7.50 (-25%)
- **20 videos**: $10.00 (-50%)

### Account Promotion (Phase 3)
- **6-hour campaign**: $3.00
- Users follow for cooldown reduction
- Separate from video credits

---

## 🛡️ Compliance

✅ **TikTok Policy Compliant**
- No automation or bots
- All actions performed manually by real users
- No credential sharing
- No guaranteed results
- Clear disclaimers throughout

✅ **Abuse Prevention**
- Rate limiting ready
- Session timeouts (5 min)
- Duplicate detection
- Exponential penalties for abandonment
- Video length restrictions (15s - 3min)

---

## 🚦 Roadmap

- [x] **Phase 1**: Core MVP ✅ **(Complete)**
  - Points system
  - Video watching & submission
  - Onboarding flow
  - Cooldown system

- [ ] **Phase 2**: Payments
  - Stripe integration
  - Credit purchasing
  - Bulk discounts

- [ ] **Phase 3**: Account Promotion
  - Promoted follows
  - Campaign management
  - Analytics

- [ ] **Phase 4**: Admin Panel
  - Content moderation
  - User management
  - System analytics

---

## 📖 Documentation

- **[README.md](README.md)** - You are here
- **[DEPLOYMENT.md](DEPLOYMENT.md)** - Complete deployment guide
- **[API.md](API.md)** - Full API reference
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - Detailed overview

---

## 🎨 Design

- **Primary Color**: #e74c60 (Pink/Red)
- **Theme**: Dark with glassmorphism effects
- **Typography**: Space Grotesk + Outfit
- **Aesthetic**: Modern, professional, engaging

---

## 🤝 Contributing

This is a commercial project. For inquiries, contact the project owner.

---

## 📄 License

Proprietary - All rights reserved

---

## 🆘 Support

1. Check documentation files
2. Review Supabase logs for database issues
3. Check browser console for frontend errors
4. Review Vercel logs for deployment issues

---

**Built with attention to detail, best practices, and user experience. Ready to deploy and scale.**

🚀 **Status**: Phase 1 Complete - Production Ready
