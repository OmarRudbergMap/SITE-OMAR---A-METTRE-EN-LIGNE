-- ============================================================
--  MISE À JOUR · Modifications DIRECTES pour les fans déjà validés
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--
--  · Un NOUVEAU profil doit toujours être validé par toi (inchangé).
--  · Un fan DÉJÀ validé peut ensuite modifier sa photo / son fond /
--    son histoire / son Instagram → visible tout de suite, sans re-validation.
--  · Un profil non validé ne peut PAS se publier tout seul (sécurité).
-- ============================================================

drop policy if exists fans_modif on fans;
create policy fans_modif on fans
  for update
  to anon, authenticated
  using (valide = true)      -- on ne peut modifier qu'une fiche DÉJÀ validée
  with check (valide = true); -- et elle reste validée (donc visible tout de suite)

-- ✅ Terminé.
