-- Run in Supabase: SQL Editor > New query > Run
create table if not exists public.registrations (
  id uuid primary key default gen_random_uuid(),
  created_at timestamptz not null default now(),
  full_name text not null check (char_length(full_name) between 2 and 100),
  email text not null check (email ~* '^[^@\s]+@[^@\s]+\.[^@\s]+$'),
  phone text not null check (phone ~ '^[0-9+ -]{10,15}$'),
  participant_type text not null check (participant_type in ('student','staff')),
  reg_no text,
  department text not null,
  year int check (year between 1 and 4),
  event text not null check (event in ('hackathon','ctf','workshop-attacks','workshop-basics')),
  team_name text,
  team_members text,
  problem_statement text,
  constraint ctf_students_only check (event <> 'ctf' or participant_type = 'student'),
  constraint hackathon_needs_team check (event <> 'hackathon' or (team_name is not null and problem_statement is not null)),
  constraint student_needs_details check (participant_type <> 'student' or (reg_no is not null and year is not null))
);

-- One registration per email (the events overlap in time, so one event per person)
create unique index if not exists registrations_email_uq on public.registrations (lower(email));

alter table public.registrations enable row level security;

-- Public visitors can only INSERT. They cannot read anyone's data.
drop policy if exists "public can register" on public.registrations;
create policy "public can register" on public.registrations
  for insert to anon, authenticated with check (true);

-- Only logged-in admins (users you create in Auth) can read / edit / delete.
drop policy if exists "admins read" on public.registrations;
create policy "admins read" on public.registrations for select to authenticated using (true);
drop policy if exists "admins update" on public.registrations;
create policy "admins update" on public.registrations for update to authenticated using (true);
drop policy if exists "admins delete" on public.registrations;
create policy "admins delete" on public.registrations for delete to authenticated using (true);
