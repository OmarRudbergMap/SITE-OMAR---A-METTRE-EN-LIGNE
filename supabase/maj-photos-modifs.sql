-- ============================================================
--  MISE À JOUR · Photos des fans + modifications avec validation
--  À exécuter UNE FOIS dans Supabase :
--  menu "SQL Editor" > "New query" > coller TOUT ceci > "Run".
--  (Sans danger : "add column if not exists" n'efface aucune donnée.)
-- ============================================================

-- 1) Nouvelles colonnes de la table "fans"
--    (photo = la photo perso du fan, enregistrée en clair dans la fiche)
alter table fans add column if not exists photo     text;
alter table fans add column if not exists chanson   text;
alter table fans add column if not exists insta     text;
alter table fans add column if not exists annee     int;
alter table fans add column if not exists concert   text;
alter table fans add column if not exists rencontre boolean;

-- 2) Autoriser un fan à MODIFIER sa fiche (photo / histoire)…
--    …mais TOUJOURS en "non validé" : la modif repasse par ta validation.
--    "with check (valide = false)" = personne ne peut se publier tout seul.
drop policy if exists update_fans_public on fans;
create policy update_fans_public on fans
  for update
  to anon, authenticated
  using (true)
  with check (valide = false);

-- ✅ Terminé. Désormais :
--    · la photo choisie à l'inscription est enregistrée ;
--    · un fan peut changer SA photo ou SON histoire ;
--    · chaque changement revient chez toi (valide = false) et n'est
--      visible par les autres qu'après que tu l'aies remis à valide = true.
