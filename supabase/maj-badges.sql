-- ============================================================
--  MISE À JOUR · Engagement & badges (v2)
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--  (Sans risque de le relancer : "if not exists" ignore ce qui existe déjà.)
--
--  Rempli par LE FAN (espace fan) :
--    vu_serie, projet_concert, omr_produits (liste de produits OMR Beauty),
--    vetement_diy, merch_tournee
--  Rempli par TOI (Table Editor) pour l'association :
--    asso_adherent, asso_dons, asso_concours, asso_rencontre, radio_day
--
--  Note : l'ancienne colonne "omr_beauty" (un simple nombre) ne sert plus,
--  elle est remplacée par "omr_produits". Tu peux l'ignorer ou la supprimer.
-- ============================================================

alter table fans add column if not exists vu_serie       boolean default false;
alter table fans add column if not exists projet_concert boolean default false;
alter table fans add column if not exists omr_produits    jsonb   default '[]'::jsonb;
alter table fans add column if not exists vetement_diy   boolean default false;
alter table fans add column if not exists merch_tournee  boolean default false;

alter table fans add column if not exists asso_adherent  boolean default false;
alter table fans add column if not exists asso_dons      integer default 0;
alter table fans add column if not exists asso_concours  integer default 0;
alter table fans add column if not exists asso_rencontre boolean default false;
alter table fans add column if not exists radio_day      boolean default false;

-- ✅ Terminé.
