# Supabase database and authentication setup

Draken Reviews includes a PostgreSQL schema for user profiles, connected repositories, review records, and findings.

## 1. Create a Supabase project

Create a project at https://supabase.com/dashboard. Keep the project URL and anon key available for application configuration.

## 2. Apply the schema

Open the project's SQL Editor and run the migration in this repository:

`supabase/migrations/0001_initial_schema.sql`

The migration creates:
- `profiles` linked to Supabase Auth users
- `projects` owned by authenticated users
- `reviews` with snippet or pull-request source metadata
- `review_findings` linked to reviews
- Row Level Security policies restricting user data to its owner

## 3. Configure environment variables

Add these to the server/deployment environment when the Supabase client integration is enabled:

```env
NEXT_PUBLIC_SUPABASE_URL=https://YOUR-PROJECT.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=YOUR_SUPABASE_ANON_KEY
```

Never expose a Supabase service-role key in browser code. If a server-only service role is introduced for trusted webhook persistence, keep it as a non-public environment variable and use it only in server routes.

## Current integration status

The database schema and row-level security policies are committed. The current dashboard review history is browser-local storage; the dashboard does not yet read or write the Supabase tables. Supabase Auth screens/session middleware and database-backed review persistence still need to be wired and tested against a real project before treating account login or cloud history as enabled.
