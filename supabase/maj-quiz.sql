-- ============================================================
--  QUIZ « Question du jour » — table de progression des fans
--  À exécuter UNE fois dans Supabase (SQL Editor) quand le service est rétabli.
--  Sans cette table, le quiz fonctionne quand même (points gardés dans le
--  navigateur du fan) ; la table sert à sauvegarder les points sur le COMPTE
--  (multi-appareils) et à les compter dans le classement mondial.
-- ============================================================

create table if not exists public.quiz_progression (
  user_id uuid primary key references auth.users(id) on delete cascade,
  points  integer not null default 0,
  cats    jsonb   not null default '{}'::jsonb,   -- bonnes réponses par catégorie
  joue    integer not null default 0,             -- nombre de questions jouées
  maj_le  timestamptz not null default now()
);

alter table public.quiz_progression enable row level security;

-- Lecture publique (nécessaire pour afficher les points dans le classement)
drop policy if exists "quiz lecture publique" on public.quiz_progression;
create policy "quiz lecture publique"
  on public.quiz_progression for select
  using (true);

-- Chaque fan connecté peut créer/mettre à jour UNIQUEMENT sa propre ligne
drop policy if exists "quiz insert own" on public.quiz_progression;
create policy "quiz insert own"
  on public.quiz_progression for insert
  with check (auth.uid() = user_id);

drop policy if exists "quiz update own" on public.quiz_progression;
create policy "quiz update own"
  on public.quiz_progression for update
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
