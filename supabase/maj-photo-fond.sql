-- ============================================================
--  MISE À JOUR · Photo de fond des histoires (image d'Omar choisie par le fan)
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--  (Sans danger : n'efface aucune donnée.)
-- ============================================================

alter table fans add column if not exists photo_histoire text;

-- ✅ Terminé. Le fan peut maintenant choisir :
--    · sa photo (le petit rond)      → colonne "photo"
--    · sa photo de fond (une image d'Omar) → colonne "photo_histoire"
--  Les règles de sécurité existantes s'appliquent déjà à cette colonne.
