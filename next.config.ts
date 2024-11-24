import type { NextConfig } from "next";

const nextConfig = {
  images: {
    domains: ['images.unsplash.com'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com'
      }
    ]
  },
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Cache-Control',
            value: 'public, max-age=0, must-revalidate'
          }
        ]
      }
    ];
  },
  webSocketConfig: {
    enabled: process.env.NEXT_PUBLIC_ENABLE_WEBSOCKET === 'true'
  },
  webpack: (config, { dev, isServer }) => {
    if (dev && !isServer) {
      config.optimization = {
        ...config.optimization,
        runtimeChunk: false
      }
    }
    return config
  }
} satisfies NextConfig;

export default nextConfig;
