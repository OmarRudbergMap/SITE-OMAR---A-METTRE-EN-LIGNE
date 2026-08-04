-- ============================================================
--  Omar Rudberg World Map · schéma de base de données Supabase
--  À exécuter dans Supabase : menu "SQL Editor" > "New query" > coller > "Run".
--  (Réglages sensibles = à ajuster avec un développeur.)
-- ============================================================

-- 1) LES FANS (points de la mappemonde)
create table if not exists fans (
  id            uuid primary key default gen_random_uuid(),
  pseudo        text not null,
  ville         text,
  pays          text,
  lat           double precision,   -- latitude (pour la carte)
  lon           double precision,   -- longitude
  date_naissance date,
  email         text,
  histoire      text,
  accord_parental boolean default false,  -- coché à l'inscription si mineur
  valide        boolean default false,     -- passe à true après modération
  created_at    timestamptz default now()
);

-- 2) LES PHOTOS
create table if not exists photos (
  id         uuid primary key default gen_random_uuid(),
  fan_id     uuid references fans(id) on delete cascade,
  url        text not null,          -- chemin/URL de la photo stockée
  legende    text,
  categorie  text,                   -- concert / rencontre / fanart ...
  annee      int,
  valide     boolean default false,  -- modération avant affichage
  created_at timestamptz default now()
);

-- 3) LES VIDÉOS (uniquement des LIENS Instagram / TikTok / YouTube)
create table if not exists videos (
  id         uuid primary key default gen_random_uuid(),
  fan_id     uuid references fans(id) on delete cascade,
  lien       text not null,          -- ex. https://youtube.com/watch?v=...
  plateforme text,                   -- youtube / instagram / tiktok
  legende    text,
  categorie  text,
  annee      int,
  valide     boolean default false,
  created_at timestamptz default now()
);

-- 4) LES CANDIDATS AUX AWARDS
create table if not exists award_candidats (
  id         uuid primary key default gen_random_uuid(),
  categorie  text not null,          -- fan / photo / video / fanproject / story
  nom        text not null,
  detail     text,
  created_at timestamptz default now()
);

-- 5) LES VOTES  (règle : 1 vote par fan, par catégorie ET par jour)
create table if not exists award_votes (
  id          uuid primary key default gen_random_uuid(),
  fan_id      uuid references fans(id) on delete cascade,
  categorie   text not null,
  candidat_id uuid references award_candidats(id) on delete cascade,
  jour        date not null default current_date,
  created_at  timestamptz default now(),
  -- empêche 2 votes le même jour dans la même catégorie pour un même fan :
  unique (fan_id, categorie, jour)
);

-- ------------------------------------------------------------
--  SÉCURITÉ (RLS) — à activer et affiner avec un développeur.
--  Idée : lecture publique du contenu VALIDÉ ; écriture réservée
--  aux fans connectés ; validation réservée aux modérateurs.
-- ------------------------------------------------------------
-- alter table fans   enable row level security;
-- alter table photos enable row level security;
-- alter table videos enable row level security;
-- alter table award_candidats enable row level security;
-- alter table award_votes     enable row level security;
