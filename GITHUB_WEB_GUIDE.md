# 🌐 Update Files Using GitHub Web Interface

Since you're using GitHub in Chrome, here's how to update the files:

## 📝 Step-by-Step: Update Files on GitHub

### Method 1: Edit Individual Files (Quick)

#### Update lib/supabase.ts

1. Go to: `https://github.com/0xFF-test/TikRewards`
2. Navigate to: `lib` folder → click `supabase.ts`
3. Click the **pencil icon** (✏️) to edit
4. Replace lines 3-4 with this:

```typescript
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://placeholder.supabase.co';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'placeholder-key';
```

5. Replace line 16 with this:

```typescript
  process.env.SUPABASE_SERVICE_ROLE_KEY || 'placeholder-key',
```

6. Scroll down → Click **"Commit changes"**
7. Click **"Commit changes"** again in the popup

#### Update next.config.js

1. Go back to main repo page
2. Click `next.config.js`
3. Click the **pencil icon** (✏️)
4. Replace ENTIRE file with this:

```javascript
/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['www.tiktok.com', 'tiktok.com'],
  },
  typescript: {
    ignoreBuildErrors: false,
  },
  eslint: {
    ignoreDuringBuilds: true,
  },
}

module.exports = nextConfig
```

5. Commit changes

#### Add next-env.d.ts

1. Go back to main repo page
2. Click **"Add file"** → **"Create new file"**
3. Name it: `next-env.d.ts`
4. Paste this content:

```typescript
/// <reference types="next" />
/// <reference types="next/image-types/global" />

// NOTE: This file should not be edited
// see https://nextjs.org/docs/basic-features/typescript for more information.
```

5. Commit the new file

---

### Method 2: Download, Edit, Upload (Easier for Multiple Files)

#### Option A: Replace Files

1. **Download the updated tikrewards folder** from this chat
   - Click the folder I sent you
   - Download it as ZIP
   - Extract on your computer

2. **Go to your GitHub repo**
   - `https://github.com/0xFF-test/TikRewards`

3. **Upload the changed files:**
   - Click on the file you want to replace (e.g., `lib/supabase.ts`)
   - Click the **trash icon** (🗑️) to delete it
   - Commit the deletion
   - Click **"Add file"** → **"Upload files"**
   - Drag the new file from your downloaded folder
   - Commit

Repeat for:
- `lib/supabase.ts`
- `next.config.js`
- `next-env.d.ts` (new file)

#### Option B: Delete & Re-upload Everything (Nuclear Option)

If easier, you can:

1. **Delete the entire repo**
   - Settings → Scroll to bottom → "Delete this repository"
   - Confirm deletion

2. **Create fresh repo**
   - Click "+" → "New repository"
   - Name: `TikRewards`
   - Create repository

3. **Upload all files**
   - Download the updated `tikrewards` folder from this chat
   - In your new empty repo, click "uploading an existing file"
   - Drag ALL files from the tikrewards folder
   - Commit

---

## 🚀 After Files Are Updated

### Add Environment Variables in Vercel

1. Go to: `vercel.com`
2. Click on your TikRewards project
3. Click **Settings** (left sidebar)
4. Click **Environment Variables**
5. Add each variable:

Click **"Add New"** for each:

**Variable 1:**
- Name: `NEXT_PUBLIC_SUPABASE_URL`
- Value: `your_supabase_url_here` (from Supabase Settings → API)
- Environments: Check all 3 (Production, Preview, Development)
- Click Save

**Variable 2:**
- Name: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- Value: `your_anon_key_here`
- Environments: Check all 3
- Click Save

**Variable 3:**
- Name: `SUPABASE_SERVICE_ROLE_KEY`
- Value: `your_service_role_key_here`
- Environments: Check all 3
- Click Save

**Variable 4:**
- Name: `JWT_SECRET`
- Value: Generate one at https://generate-secret.vercel.app/32
- Environments: Check all 3
- Click Save

**Variable 5:**
- Name: `NEXT_PUBLIC_APP_URL`
- Value: `https://your-project-name.vercel.app` (your Vercel URL)
- Environments: Check all 3
- Click Save

**Variable 6:**
- Name: `NEXT_PUBLIC_TIKTOK_MAIN_ACCOUNT`
- Value: `@0xFinanceFirst`
- Environments: Check all 3
- Click Save

### Redeploy

1. Go to **Deployments** (left sidebar)
2. Click the **"..."** menu on the latest deployment
3. Click **"Redeploy"**
4. Wait for build to complete
5. ✅ Should work now!

---

## 📋 Quick Checklist

- [ ] Updated `lib/supabase.ts` on GitHub
- [ ] Updated `next.config.js` on GitHub
- [ ] Added `next-env.d.ts` on GitHub
- [ ] Added all 6 environment variables in Vercel
- [ ] Triggered redeploy in Vercel
- [ ] Build succeeded
- [ ] Site is live

---

## 🎯 Expected Result

When successful, you'll see in Vercel:
```
✓ Building
✓ Compiled successfully
```

Your site will be live at: `https://your-project.vercel.app`

Test by visiting the URL - you should see the login page!

---

## ❓ Need Help?

If you get stuck:
1. Tell me which step you're on
2. Share any error messages you see
3. I'll give you exact instructions!
