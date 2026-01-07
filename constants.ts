export const POINTS = {
  BASE_WATCH: parseInt(process.env.BASE_WATCH_POINTS || '10'),
  LIKE: parseInt(process.env.LIKE_POINTS || '5'),
  COMMENT: parseInt(process.env.COMMENT_POINTS || '10'),
  COMPLETION_MULTIPLIER: parseFloat(process.env.COMPLETION_MULTIPLIER || '1.5'),
  MINIMUM_TO_SUBMIT: parseInt(process.env.MINIMUM_POINTS_TO_SUBMIT || '3800'),
} as const;

export const COOLDOWN = {
  BASE_VIDEOS: parseInt(process.env.BASE_COOLDOWN_VIDEOS || '10'),
  FOLLOW_REDUCTION: parseFloat(process.env.FOLLOW_COOLDOWN_REDUCTION || '0.25'),
  MINIMUM_SECONDS: parseInt(process.env.MINIMUM_COOLDOWN_SECONDS || '30'),
} as const;

export const VIDEO = {
  MIN_LENGTH_SECONDS: parseInt(process.env.MIN_VIDEO_LENGTH_SECONDS || '15'),
  MAX_LENGTH_SECONDS: parseInt(process.env.MAX_VIDEO_LENGTH_SECONDS || '180'),
  WATCH_COMPLETION_THRESHOLD: 0.9, // 90% of video length
  FREE_SUBMISSION_LIMIT: parseInt(process.env.FREE_SUBMISSION_LIFETIME_LIMIT || '2'),
  PAID_WAIT_MINUTES: parseInt(process.env.PAID_SUBMISSION_WAIT_MINUTES || '30'),
} as const;

export const SESSION = {
  TIMEOUT_MINUTES: parseInt(process.env.SESSION_TIMEOUT_MINUTES || '5'),
} as const;

export const ABANDONMENT_PENALTIES = [15, 30, 60, 120] as const;

export const MAIN_ACCOUNT = process.env.NEXT_PUBLIC_TIKTOK_MAIN_ACCOUNT || '@0xFinanceFirst';

export const calculateTotalPoints = (
  watchCompleted: boolean,
  likeClicked: boolean,
  commentClicked: boolean
): number => {
  if (!watchCompleted) return 0;

  let total = POINTS.BASE_WATCH;
  
  if (likeClicked) total += POINTS.LIKE;
  if (commentClicked) total += POINTS.COMMENT;
  
  // Apply completion multiplier if all three actions completed
  if (watchCompleted && likeClicked && commentClicked) {
    total = Math.round(total * POINTS.COMPLETION_MULTIPLIER);
  }
  
  return total;
};

export const calculateAbandonmentPenalty = (consecutiveCount: number): number => {
  const index = Math.min(consecutiveCount - 1, ABANDONMENT_PENALTIES.length - 1);
  return ABANDONMENT_PENALTIES[index];
};

export const extractTikTokVideoId = (url: string): string | null => {
  try {
    // Handle different TikTok URL formats
    // https://www.tiktok.com/@username/video/1234567890
    // https://vm.tiktok.com/shortcode/
    // https://www.tiktok.com/t/shortcode/
    
    const patterns = [
      /tiktok\.com\/@[\w.-]+\/video\/(\d+)/,
      /tiktok\.com\/v\/(\d+)/,
      /vm\.tiktok\.com\/([\w-]+)/,
      /tiktok\.com\/t\/([\w-]+)/,
    ];
    
    for (const pattern of patterns) {
      const match = url.match(pattern);
      if (match) return match[1];
    }
    
    return null;
  } catch {
    return null;
  }
};

export const isValidTikTokUrl = (url: string): boolean => {
  try {
    const urlObj = new URL(url);
    return (
      (urlObj.hostname === 'www.tiktok.com' || 
       urlObj.hostname === 'tiktok.com' ||
       urlObj.hostname === 'vm.tiktok.com') &&
      extractTikTokVideoId(url) !== null
    );
  } catch {
    return false;
  }
};
