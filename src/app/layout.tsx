import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title: 'Draken Reviews — AI Code Intelligence', description: 'Understand your code before it ships. AI-powered code review, risk detection and actionable fixes.' };
export default function RootLayout({ children }: Readonly<{ children: React.ReactNode }>) { return <html lang="en"><body>{children}</body></html>; }
