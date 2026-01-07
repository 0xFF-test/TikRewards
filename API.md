# API Documentation

## Authentication

All protected endpoints require a JWT token in the Authorization header:

```
Authorization: Bearer <token>
```

## Endpoints

### POST /api/auth/login

Authenticate user with email (creates account if doesn't exist).

**Request Body:**
```json
{
  "email": "user@example.com"
}
```

**Response (200):**
```json
{
  "success": true,
  "token": "eyJhbGciOiJIUzI1NiIs...",
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "role": "viewer",
    "points_balance": 0,
    "onboarding_completed": false,
    "followed_main_account": false,
    "free_submissions_used": 0
  }
}
```

**Error Responses:**
- 400: Invalid email format
- 500: Server error

---

### POST /api/videos/submit

Submit a TikTok video to the platform.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "tiktok_url": "https://www.tiktok.com/@username/video/1234567890",
  "is_paid": false
}
```

**Response (200):**
```json
{
  "success": true,
  "video": {
    "id": "uuid",
    "tiktok_url": "https://www.tiktok.com/@username/video/1234567890",
    "status": "pending",
    "is_paid": false,
    "estimatedWaitMinutes": 30
  },
  "message": "Video submitted! It will be activated in 30 minutes."
}
```

**Error Responses:**
- 400: Invalid TikTok URL
- 400: Video already submitted
- 403: Onboarding not completed
- 403: Free submission limit reached
- 403: Insufficient points
- 401: Unauthorized

---

### GET /api/videos/next

Get the next video in queue for the user to watch.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200) - Video Available:**
```json
{
  "success": true,
  "video": {
    "id": "uuid",
    "tiktok_url": "https://www.tiktok.com/@username/video/1234567890",
    "video_length_seconds": 45,
    "is_paid": true
  },
  "sessionId": "session-uuid",
  "expiresAt": "2024-01-01T12:05:00Z"
}
```

**Response (200) - On Cooldown:**
```json
{
  "onCooldown": true,
  "videosWatched": 10,
  "cooldownReduction": 0,
  "message": "You have reached the viewing limit. Follow promoted accounts to reduce cooldown."
}
```

**Response (200) - Requires Onboarding:**
```json
{
  "requiresOnboarding": true,
  "message": "Please complete onboarding first"
}
```

**Response (200) - No Videos:**
```json
{
  "noVideos": true,
  "useDefaultContent": true,
  "message": "No submitted videos available at this time"
}
```

**Error Responses:**
- 401: Unauthorized
- 500: Server error

---

### POST /api/videos/view

Complete a video viewing session and award points.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "video_id": "uuid",
  "session_id": "session-uuid",
  "watch_seconds": 45,
  "watch_completed": true,
  "like_clicked": true,
  "comment_clicked": true
}
```

**Response (200):**
```json
{
  "success": true,
  "pointsEarned": 38,
  "newBalance": 3838,
  "isAbandonment": false,
  "completion": {
    "watch_completed": true,
    "like_clicked": true,
    "comment_clicked": true
  }
}
```

**Response (200) - Abandonment:**
```json
{
  "success": true,
  "pointsEarned": -15,
  "newBalance": 85,
  "isAbandonment": true,
  "completion": {
    "watch_completed": false,
    "like_clicked": false,
    "comment_clicked": false
  }
}
```

**Error Responses:**
- 400: Missing required fields
- 404: View session not found
- 404: Video not found
- 401: Unauthorized
- 500: Server error

---

### POST /api/actions/like

Track when user clicks to like a video on TikTok.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "video_id": "uuid",
  "session_id": "session-uuid"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Like action tracked"
}
```

**Error Responses:**
- 400: Missing required fields
- 500: Failed to update like status
- 401: Unauthorized

---

### POST /api/actions/comment

Track when user clicks to comment on a video on TikTok.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "video_id": "uuid",
  "session_id": "session-uuid"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Comment action tracked"
}
```

**Error Responses:**
- 400: Missing required fields
- 500: Failed to update comment status
- 401: Unauthorized

---

### POST /api/actions/follow

Track when user follows a TikTok account.

**Headers:**
```
Authorization: Bearer <token>
```

**Request Body:**
```json
{
  "tiktok_username": "@0xFinanceFirst"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Follow action tracked successfully"
}
```

**Error Responses:**
- 400: TikTok username is required
- 400: You have already followed this account
- 401: Unauthorized
- 500: Server error

---

### GET /api/users/points

Get current user information and points balance.

**Headers:**
```
Authorization: Bearer <token>
```

**Response (200):**
```json
{
  "success": true,
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "points_balance": 3800,
    "free_submissions_used": 1,
    "onboarding_completed": true,
    "followed_main_account": true,
    "onboarding_videos_watched": 2
  }
}
```

**Error Responses:**
- 401: Unauthorized
- 500: Server error

---

## Error Response Format

All errors follow this format:

```json
{
  "error": "Error message description"
}
```

Some errors include additional context:

```json
{
  "error": "You need at least 3800 points to submit a video",
  "requiredPoints": 3800,
  "currentPoints": 1250
}
```

## Rate Limiting

Currently not implemented. Will be added in future versions with limits:
- 100 requests per hour per IP
- 1000 requests per day per user

## Points Calculation

### Watch Video Points
- Base: 10 points (90% completion required)
- Like: +5 points
- Comment: +10 points
- All 3 completed: 1.5x multiplier = 38 points total

### Abandonment Penalties
- 1st abandonment: -15 points
- 2nd consecutive: -30 points
- 3rd consecutive: -60 points
- 4th+ consecutive: -120 points

Points never go below 0.

## Session Management

- Sessions expire after 5 minutes of inactivity
- One active session per user
- Videos are locked during active sessions
- Abandoned sessions are cleaned up automatically

## Video Validation

- URL must be valid TikTok format
- Video length: 15 seconds - 3 minutes
- Each video can only be submitted once
- TikTok video ID must be extractable from URL

## Cooldown System

- Base: 10 videos before cooldown
- Each follow reduces cooldown by 25%
- Following @0xFinanceFirst gives 100% reduction
- Minimum cooldown: 30 seconds between videos
