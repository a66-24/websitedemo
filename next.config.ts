import type { NextConfig } from "next";

const nextConfig = {
  output: 'export',
  distDir: 'dist',
  images: {
    domains: ['images.unsplash.com'],
    remotePatterns: [
      {
        protocol: 'https',
        hostname: 'images.unsplash.com'
      }
    ],
    unoptimized: true
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
