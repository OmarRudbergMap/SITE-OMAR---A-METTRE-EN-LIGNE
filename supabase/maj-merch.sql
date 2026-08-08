-- ============================================================
--  MISE À JOUR · Merch de tournée (badges tee-shirt)
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--  Ajoute la liste du merch de tournée possédé par chaque fan.
--  Sans risque de le relancer.
-- ============================================================
alter table fans add column if not exists merch_tournees jsonb default '[]'::jsonb;
-- ✅ Terminé.
