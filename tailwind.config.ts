import type { Config } from 'tailwindcss';
const config: Config = { content: ['./src/**/*.{js,ts,jsx,tsx,mdx}'], theme: { extend: { colors: { ink: '#090d18', panel: '#111827', line: '#263244', accent: '#7c6cff', mint: '#55e6c1' }, boxShadow: { glow: '0 0 40px rgba(124,108,255,.16)' } } }, plugins: [] };
export default config;
