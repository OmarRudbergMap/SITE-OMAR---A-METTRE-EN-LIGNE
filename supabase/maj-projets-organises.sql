-- ============================================================
--  MISE À JOUR · Nombre de projets organisés (modifiable) sur la fiche
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--
--  · Avant : une simple case « J'ai organisé un projet » (oui/non).
--  · Maintenant : un NOMBRE modifiable (combien de projets organisés),
--    qui s'affiche dans le compteur « projets » de la fiche.
-- ============================================================

alter table fans add column if not exists projets_organises int default 0;

-- ✅ Terminé.
