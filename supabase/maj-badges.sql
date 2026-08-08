-- ============================================================
--  MISE À JOUR · Engagement & badges
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--
--  Colonnes remplies par LE FAN (dans son espace fan) :
--    vu_serie, projet_concert, omr_beauty, vetement_diy, merch_tournee
--  Colonnes que TU remplis toi-même (Table Editor), pour l'association :
--    asso_adherent, asso_dons (compteur), asso_concours (compteur),
--    asso_rencontre, radio_day (Omar Global Radio Day)
--
--  Sans risque : "if not exists" = si une colonne existe déjà, rien ne se passe.
-- ============================================================

alter table fans add column if not exists vu_serie       boolean default false;
alter table fans add column if not exists projet_concert boolean default false;
alter table fans add column if not exists omr_beauty     integer default 0;
alter table fans add column if not exists vetement_diy   boolean default false;
alter table fans add column if not exists merch_tournee  boolean default false;

alter table fans add column if not exists asso_adherent  boolean default false;
alter table fans add column if not exists asso_dons      integer default 0;
alter table fans add column if not exists asso_concours  integer default 0;
alter table fans add column if not exists asso_rencontre boolean default false;
alter table fans add column if not exists radio_day      boolean default false;

-- ✅ Terminé.
