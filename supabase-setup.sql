-- Table matching the app's report object exactly
create table public.reports (
  id         text primary key,                 -- 'r_<timestamp>_<random>' from the app
  category   text not null check (category in ('pothole','accident','insecurity','closure')),
  lat        double precision not null,
  lng        double precision not null,
  address    text,
  note       text,
  photo      text,                              -- base64 data URL, may be null
  ts         bigint not null,                   -- Date.now() milliseconds
  created_at timestamptz not null default now()
);

create index reports_ts_idx on public.reports (ts desc);

-- RLS is the ONLY thing protecting this table, because the anon key is public.
alter table public.reports enable row level security;

create policy "public can read reports"
  on public.reports for select to anon using (true);

create policy "public can add reports"
  on public.reports for insert to anon with check (true);

-- See the warning about this one before running it.
create policy "public can delete reports"
  on public.reports for delete to anon using (true);

-- Required for live updates between visitors
alter publication supabase_realtime add table public.reports;
