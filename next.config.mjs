/** @type {import('next').NextConfig} */
const isProduction = process.env.NODE_ENV === 'production';
const nextConfig = {
  output: 'export',
  ...(isProduction ? { basePath: '/Draken-Reviews' } : {}),
  images: { unoptimized: true },
  poweredByHeader: false,
};
export default nextConfig;
