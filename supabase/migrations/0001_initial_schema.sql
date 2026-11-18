-- Draken Reviews: Supabase PostgreSQL schema
-- Run this migration in the Supabase SQL editor or through the Supabase CLI.

create extension if not exists pgcrypto;

create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.projects (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null,
  github_owner text,
  github_repo text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique(owner_id, github_owner, github_repo)
);

create table if not exists public.reviews (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  project_id uuid references public.projects(id) on delete set null,
  source text not null default 'snippet' check (source in ('snippet','pull_request')),
  language text not null default 'unknown',
  title text,
  summary text not null default '',
  score integer not null default 0 check (score between 0 and 100),
  status text not null default 'completed' check (status in ('queued','running','completed','failed')),
  github_pr_number integer,
  github_pr_url text,
  created_at timestamptz not null default now()
);

create table if not exists public.review_findings (
  id uuid primary key default gen_random_uuid(),
  review_id uuid not null references public.reviews(id) on delete cascade,
  severity text not null check (severity in ('critical','high','medium','low','info')),
  title text not null,
  file_path text,
  line_number integer,
  explanation text not null,
  recommendation text not null default '',
  created_at timestamptz not null default now()
);

create index if not exists reviews_owner_created_idx on public.reviews(owner_id, created_at desc);
create index if not exists review_findings_review_idx on public.review_findings(review_id);

alter table public.profiles enable row level security;
alter table public.projects enable row level security;
alter table public.reviews enable row level security;
alter table public.review_findings enable row level security;

drop policy if exists "Profiles are readable by owner" on public.profiles;
create policy "Profiles are readable by owner" on public.profiles for select using (auth.uid() = id);
drop policy if exists "Profiles are editable by owner" on public.profiles;
create policy "Profiles are editable by owner" on public.profiles for update using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "Projects are manageable by owner" on public.projects;
create policy "Projects are manageable by owner" on public.projects for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

drop policy if exists "Reviews are manageable by owner" on public.reviews;
create policy "Reviews are manageable by owner" on public.reviews for all using (auth.uid() = owner_id) with check (auth.uid() = owner_id);

drop policy if exists "Findings are visible through owned reviews" on public.review_findings;
create policy "Findings are visible through owned reviews" on public.review_findings for select using (
  exists (select 1 from public.reviews r where r.id = review_id and r.owner_id = auth.uid())
);
drop policy if exists "Findings can be inserted through owned reviews" on public.review_findings;
create policy "Findings can be inserted through owned reviews" on public.review_findings for insert with check (
  exists (select 1 from public.reviews r where r.id = review_id and r.owner_id = auth.uid())
);

create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = ''
as $$
begin
  insert into public.profiles (id, display_name, avatar_url)
  values (new.id, new.raw_user_meta_data ->> 'full_name', new.raw_user_meta_data ->> 'avatar_url')
  on conflict (id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
after insert on auth.users
for each row execute procedure public.handle_new_user();
