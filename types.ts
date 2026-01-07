export interface User {
  id: string;
  email: string;
  role: 'viewer' | 'creator' | 'admin';
  points_balance: number;
  free_submissions_used: number;
  onboarding_completed: boolean;
  followed_main_account: boolean;
  onboarding_videos_watched: number;
  created_at: string;
  updated_at: string;
}

export interface Video {
  id: string;
  tiktok_url: string;
  tiktok_video_id: string;
  creator_id: string;
  status: 'pending' | 'active' | 'completed' | 'removed';
  priority_score: number;
  is_paid: boolean;
  video_length_seconds: number | null;
  total_views: number;
  total_likes: number;
  total_comments: number;
  created_at: string;
  activated_at: string | null;
  completed_at: string | null;
}

export interface ViewLog {
  id: string;
  user_id: string;
  video_id: string;
  watch_seconds: number;
  watch_completed: boolean;
  like_clicked: boolean;
  comment_clicked: boolean;
  points_awarded: number;
  session_id: string;
  created_at: string;
  completed_at: string | null;
}

export interface PointsLog {
  id: string;
  user_id: string;
  action: string;
  points_change: number;
  balance_after: number;
  video_id: string | null;
  metadata: Record<string, any> | null;
  created_at: string;
}

export interface AbandonmentLog {
  id: string;
  user_id: string;
  video_id: string;
  consecutive_count: number;
  points_penalty: number;
  created_at: string;
}

export interface FollowTracking {
  id: string;
  user_id: string;
  tiktok_username: string;
  verified: boolean;
  created_at: string;
}

export interface PromotedAccount {
  id: string;
  tiktok_username: string;
  display_name: string | null;
  promotion_slots: number;
  active_until: string | null;
  total_follows: number;
  created_at: string;
  updated_at: string;
}

export interface UserSession {
  id: string;
  user_id: string;
  video_id: string;
  session_id: string;
  started_at: string;
  expires_at: string;
  is_active: boolean;
}

export interface VideoWithCreator extends Video {
  creator?: User;
}

export interface ViewLogWithDetails extends ViewLog {
  video?: Video;
  user?: User;
}

export interface CooldownStatus {
  on_cooldown: boolean;
  videos_watched_in_session: number;
  cooldown_reduction_percent: number;
}

export interface NextVideo {
  video_id: string;
  tiktok_url: string;
  video_length_seconds: number;
  is_paid: boolean;
}
