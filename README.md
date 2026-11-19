# NCSD 2026 registration site (Vercel + Supabase)

## 1. Supabase (5 min)
1. supabase.com > New project.
2. SQL Editor > paste `schema.sql` > Run.
3. Authentication > Users > Add user (email + password) for each organizer. These are your admin logins.
4. Authentication > Sign In / Providers > Email: turn OFF "Allow new users to sign up" (otherwise anyone could become an admin).
5. Project Settings > API: copy the Project URL and the `anon public` key.

## 2. Configure
Open `public/config.js`, paste the URL and anon key, and replace the 3 problem statements.
Never put the `service_role` key anywhere in this project.

## 3. Deploy on Vercel
- Push this folder to a GitHub repo, then Vercel > Add New > Project > import it > Deploy (no build command needed; `vercel.json` sets the output folder to `public`).
- Or from a terminal: `npm i -g vercel && vercel --prod`.

## URLs
- `/` public registration page
- `/admin` organizer dashboard (login, search, filter, CSV export, delete)

## Rules built in
- One registration per email (events overlap in time).
- CTF: students only. Workshop 1: CSE/allied departments. Workshop 2: other departments.
- Hackathon needs team name + problem statement.
- Public can only insert; only signed-in admins can read, edit or delete (Row Level Security).
