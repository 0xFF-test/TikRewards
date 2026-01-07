-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users table
CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email VARCHAR(255) UNIQUE NOT NULL,
  role VARCHAR(20) DEFAULT 'viewer' CHECK (role IN ('viewer', 'creator', 'admin')),
  points_balance INTEGER DEFAULT 0 CHECK (points_balance >= 0),
  free_submissions_used INTEGER DEFAULT 0 CHECK (free_submissions_used >= 0),
  onboarding_completed BOOLEAN DEFAULT FALSE,
  followed_main_account BOOLEAN DEFAULT FALSE,
  onboarding_videos_watched INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Videos table
CREATE TABLE videos (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tiktok_url VARCHAR(500) UNIQUE NOT NULL,
  tiktok_video_id VARCHAR(100) UNIQUE NOT NULL,
  creator_id UUID REFERENCES users(id) ON DELETE CASCADE,
  status VARCHAR(20) DEFAULT 'pending' CHECK (status IN ('pending', 'active', 'completed', 'removed')),
  priority_score INTEGER DEFAULT 0,
  is_paid BOOLEAN DEFAULT FALSE,
  video_length_seconds INTEGER,
  total_views INTEGER DEFAULT 0,
  total_likes INTEGER DEFAULT 0,
  total_comments INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  activated_at TIMESTAMP WITH TIME ZONE,
  completed_at TIMESTAMP WITH TIME ZONE
);

-- View logs table
CREATE TABLE view_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
  watch_seconds INTEGER DEFAULT 0,
  watch_completed BOOLEAN DEFAULT FALSE,
  like_clicked BOOLEAN DEFAULT FALSE,
  comment_clicked BOOLEAN DEFAULT FALSE,
  points_awarded INTEGER DEFAULT 0,
  session_id VARCHAR(100),
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  completed_at TIMESTAMP WITH TIME ZONE,
  UNIQUE(user_id, video_id)
);

-- Points logs table
CREATE TABLE points_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  action VARCHAR(50) NOT NULL,
  points_change INTEGER NOT NULL,
  balance_after INTEGER NOT NULL,
  video_id UUID REFERENCES videos(id) ON DELETE SET NULL,
  metadata JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Abandonment tracking table
CREATE TABLE abandonment_logs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
  consecutive_count INTEGER DEFAULT 1,
  points_penalty INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Follow tracking table
CREATE TABLE follow_tracking (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  tiktok_username VARCHAR(100) NOT NULL,
  verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  UNIQUE(user_id, tiktok_username)
);

-- Promoted accounts table
CREATE TABLE promoted_accounts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  tiktok_username VARCHAR(100) UNIQUE NOT NULL,
  display_name VARCHAR(255),
  promotion_slots INTEGER DEFAULT 0,
  active_until TIMESTAMP WITH TIME ZONE,
  total_follows INTEGER DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- User sessions table for video locking
CREATE TABLE user_sessions (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
  session_id VARCHAR(100) NOT NULL,
  started_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  UNIQUE(user_id, session_id)
);

-- Indexes for performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_videos_status ON videos(status);
CREATE INDEX idx_videos_priority ON videos(priority_score DESC, created_at ASC);
CREATE INDEX idx_videos_creator ON videos(creator_id);
CREATE INDEX idx_view_logs_user ON view_logs(user_id);
CREATE INDEX idx_view_logs_video ON view_logs(video_id);
CREATE INDEX idx_points_logs_user ON points_logs(user_id);
CREATE INDEX idx_user_sessions_active ON user_sessions(is_active, expires_at);

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_promoted_accounts_updated_at BEFORE UPDATE ON promoted_accounts
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Function to get next video in queue
CREATE OR REPLACE FUNCTION get_next_video_for_user(p_user_id UUID)
RETURNS TABLE (
  video_id UUID,
  tiktok_url VARCHAR,
  video_length_seconds INTEGER,
  is_paid BOOLEAN
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    v.id,
    v.tiktok_url,
    v.video_length_seconds,
    v.is_paid
  FROM videos v
  WHERE v.status = 'active'
    AND v.id NOT IN (
      SELECT vl.video_id 
      FROM view_logs vl 
      WHERE vl.user_id = p_user_id
    )
    AND v.id NOT IN (
      SELECT us.video_id
      FROM user_sessions us
      WHERE us.is_active = TRUE
        AND us.expires_at > NOW()
        AND us.user_id != p_user_id
    )
  ORDER BY v.is_paid DESC, v.priority_score DESC, v.created_at ASC
  LIMIT 1;
END;
$$ LANGUAGE plpgsql;

-- Function to check cooldown status
CREATE OR REPLACE FUNCTION check_user_cooldown(p_user_id UUID)
RETURNS TABLE (
  on_cooldown BOOLEAN,
  videos_watched_in_session INTEGER,
  cooldown_reduction_percent NUMERIC
) AS $$
DECLARE
  v_videos_watched INTEGER;
  v_follow_count INTEGER;
  v_base_cooldown INTEGER := 10; -- BASE_COOLDOWN_VIDEOS
  v_reduction NUMERIC;
BEGIN
  -- Count videos watched in current session (last hour)
  SELECT COUNT(*)
  INTO v_videos_watched
  FROM view_logs
  WHERE user_id = p_user_id
    AND watch_completed = TRUE
    AND created_at > NOW() - INTERVAL '1 hour';
  
  -- Count follows for cooldown reduction
  SELECT COUNT(*)
  INTO v_follow_count
  FROM follow_tracking
  WHERE user_id = p_user_id;
  
  -- Calculate reduction (25% per follow, max 100%)
  v_reduction := LEAST(v_follow_count * 0.25, 1.0);
  
  -- If no follows and followed main account, give 100% reduction
  IF v_follow_count = 0 THEN
    SELECT followed_main_account INTO v_reduction
    FROM users
    WHERE id = p_user_id;
    
    IF v_reduction THEN
      v_reduction := 1.0;
    ELSE
      v_reduction := 0.0;
    END IF;
  END IF;
  
  RETURN QUERY
  SELECT 
    v_videos_watched >= v_base_cooldown AS on_cooldown,
    v_videos_watched,
    v_reduction * 100;
END;
$$ LANGUAGE plpgsql;
