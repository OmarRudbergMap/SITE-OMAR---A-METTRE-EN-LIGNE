-- ============================================================
--  MISE À JOUR · Comptes fans (chaque fiche reliée à un compte)
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query > coller > Run.
--
--  · Chaque fiche appartient à un compte (user_id).
--  · Un fan connecté ne peut voir/modifier QUE sa propre fiche.
--  · Les nouveaux profils restent en attente de TA validation.
--  · Les fiches validées sont visibles par tous (lecture publique).
-- ============================================================

-- 1) Colonne qui relie une fiche à un compte
alter table fans add column if not exists user_id uuid references auth.users(id);

-- 2) On repart sur des règles de sécurité propres, basées sur le compte connecté
drop policy if exists fans_lecture      on fans;
drop policy if exists fans_lecture_soi  on fans;
drop policy if exists fans_insertion    on fans;
drop policy if exists fans_modif        on fans;

-- lecture publique du contenu validé
create policy fans_lecture on fans
  for select using (valide = true);

-- un fan connecté peut lire SA propre fiche (même pas encore validée)
create policy fans_lecture_soi on fans
  for select to authenticated using (auth.uid() = user_id);

-- un fan connecté crée SA fiche (non validée au départ)
create policy fans_insertion on fans
  for insert to authenticated with check (auth.uid() = user_id and valide = false);

-- un fan connecté modifie SA fiche (et seulement la sienne)
create policy fans_modif on fans
  for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- ✅ Terminé.
