-- ============================================================
--  OMAR RUDBERG WORLD AWARDS — étape 1
--  À lancer dans Supabase : SQL Editor → New query → coller → Run
--  Projet : hdxrajqcawqhpmqypujz (celui avec la table « fans »)
--  Sans danger : cette commande n'efface rien, elle ajoute une colonne.
-- ============================================================

alter table public.awards_config
  add column if not exists phase text default 'avant';

-- on met l'événement sur la première étape
insert into public.awards_config (id, ouvert, phase)
values (1, false, 'avant')
on conflict (id) do update set phase = coalesce(public.awards_config.phase, 'avant');

-- vérification : doit afficher une ligne avec phase = avant
select id, ouvert, fin, phase from public.awards_config where id = 1;
