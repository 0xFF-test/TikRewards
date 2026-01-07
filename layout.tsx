import './globals.css'
import type { Metadata } from 'next'

export const metadata: Metadata = {
  title: 'TikRewards - Earn Points Watching TikTok Videos',
  description: 'Earn points by watching TikTok videos and engaging with content',
}

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <head>
        <link
          href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
          rel="stylesheet"
        />
      </head>
      <body>{children}</body>
    </html>
  )
}
