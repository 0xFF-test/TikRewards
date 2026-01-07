/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  images: {
    domains: ['www.tiktok.com', 'tiktok.com'],
  },
  typescript: {
    // Allow build to succeed even with type errors (not recommended for production)
    ignoreBuildErrors: false,
  },
  eslint: {
    // Allow build to succeed even with eslint errors during builds
    ignoreDuringBuilds: true,
  },
}

module.exports = nextConfig
