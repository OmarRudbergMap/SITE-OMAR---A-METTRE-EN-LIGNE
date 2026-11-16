-- ============================================================
--  OMAR RUDBERG WORLD AWARDS — étape 2 : résultats vraiment secrets
--  À NE LANCER QU'AVANT L'OUVERTURE DES VOTES (vers le 10 décembre),
--  et on le fera ensemble pour vérifier juste après que le vote marche.
--
--  Ce que ça fait :
--   1. plus personne ne peut lire les votes des autres ;
--   2. chacun peut toujours voter et modifier SON vote ;
--   3. les totaux ne sont calculés par le serveur que lorsque
--      l'étape de l'événement est « ceremonie ».
-- ============================================================

alter table public.awards_votes enable row level security;

drop policy if exists "awards_votes_select_tous" on public.awards_votes;
drop policy if exists "awards_votes_moi_select" on public.awards_votes;
drop policy if exists "awards_votes_moi_insert" on public.awards_votes;
drop policy if exists "awards_votes_moi_update" on public.awards_votes;
drop policy if exists "awards_votes_moi_delete" on public.awards_votes;

-- je ne vois que mes propres votes
create policy "awards_votes_moi_select" on public.awards_votes
  for select using (auth.uid() = user_id);

-- je ne peux voter que pour moi
create policy "awards_votes_moi_insert" on public.awards_votes
  for insert with check (auth.uid() = user_id);
create policy "awards_votes_moi_update" on public.awards_votes
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
create policy "awards_votes_moi_delete" on public.awards_votes
  for delete using (auth.uid() = user_id);

-- un seul vote par personne, par catégorie et par jour (verrou côté base)
create unique index if not exists awards_votes_unique
  on public.awards_votes (user_id, categorie, jour);

-- les totaux officiels, donnés par le serveur uniquement le jour de la cérémonie
create or replace function public.awards_resultats()
returns table(cand_id bigint, votes bigint)
language sql
security definer
set search_path = public
as $$
  select v.cand_id, count(*)::bigint
  from public.awards_votes v
  where (select coalesce(c.phase,'') from public.awards_config c where c.id = 1) = 'ceremonie'
  group by v.cand_id;
$$;

grant execute on function public.awards_resultats() to anon, authenticated;

-- vérification : doit renvoyer 0 ligne tant que l'étape n'est pas « ceremonie »
select * from public.awards_resultats();
