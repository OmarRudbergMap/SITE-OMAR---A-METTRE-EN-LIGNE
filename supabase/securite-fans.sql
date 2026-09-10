-- ============================================================
--  SÉCURITÉ · Protéger les dates de naissance + nettoyer les règles
--  de la table "fans"
--  À exécuter UNE FOIS dans Supabase : SQL Editor > New query >
--  tout coller > Run.   (Projet : hdxrajqcawqhpmqypujz)
--
--  CE QUE ÇA FAIT :
--   1) Les dates de naissance complètes sont déplacées dans un coffre
--      privé ("fans_prive") que PERSONNE ne peut lire depuis le site.
--      Le site ne reçoit plus que l'ÂGE et le JOUR/MOIS d'anniversaire
--      (ce qu'il affichait déjà).
--   2) Chaque nouvelle date saisie par un fan va automatiquement
--      dans le coffre (rien à changer côté fans).
--   3) Les règles de sécurité de la table "fans" sont remises au propre :
--        · tout le monde voit les fiches validées ;
--        · un fan connecté voit / crée / modifie SA fiche uniquement ;
--        · la modératrice (elisabeth.sikora@orange.fr) peut tout gérer ;
--        · un visiteur NON connecté ne peut plus rien modifier.
--   4) Une copie des anciennes règles est gardée (table
--      "_sauvegarde_regles_fans") au cas où.
--
--  Sans risque de le relancer une 2e fois.
-- ============================================================

-- 0) Sauvegarde des anciennes règles (pour pouvoir revenir en arrière)
create table if not exists public._sauvegarde_regles_fans as
  select now() as sauvegarde_le, * from pg_policies where tablename = 'fans' and schemaname = 'public';
alter table public._sauvegarde_regles_fans enable row level security;
revoke all on public._sauvegarde_regles_fans from anon, authenticated;

-- 1) Le coffre privé des dates de naissance
create table if not exists public.fans_prive (
  fan_id         uuid primary key references public.fans(id) on delete cascade,
  date_naissance date
);
alter table public.fans_prive enable row level security;   -- aucune règle = aucune lecture publique
revoke all on public.fans_prive from anon, authenticated;

-- 2) Déplacement automatique : chaque date saisie part dans le coffre
create or replace function public.fans_ranger_naissance()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.date_naissance is not null then
    insert into public.fans_prive (fan_id, date_naissance)
    values (new.id, new.date_naissance)
    on conflict (fan_id) do update set date_naissance = excluded.date_naissance;
    new.date_naissance := null;
  end if;
  return new;
end;
$$;

-- (le coffre a besoin que la fiche existe : on range APRÈS la création)
create or replace function public.fans_ranger_naissance_apres()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if new.date_naissance is not null then
    insert into public.fans_prive (fan_id, date_naissance)
    values (new.id, new.date_naissance)
    on conflict (fan_id) do update set date_naissance = excluded.date_naissance;
    update public.fans set date_naissance = null where id = new.id;
  end if;
  return null;
end;
$$;

drop trigger if exists fans_naissance_maj on public.fans;
create trigger fans_naissance_maj
  before update of date_naissance on public.fans
  for each row execute function public.fans_ranger_naissance();

drop trigger if exists fans_naissance_creation on public.fans;
create trigger fans_naissance_creation
  after insert on public.fans
  for each row execute function public.fans_ranger_naissance_apres();

-- 3) On range les dates déjà enregistrées, puis on les efface de la table publique
insert into public.fans_prive (fan_id, date_naissance)
  select id, date_naissance from public.fans where date_naissance is not null
on conflict (fan_id) do update set date_naissance = excluded.date_naissance;
update public.fans set date_naissance = null where date_naissance is not null;

-- 4) Ce que le site a le droit de lire (sans jamais voir la date complète)
--    a) pour tout le monde : âge + jour/mois d'anniversaire des fiches validées
create or replace function public.fans_ages_anniv()
returns table (id text, age int, anniv text)
language sql
stable
security definer
set search_path = public
as $$
  select f.id::text,
         extract(year from age(current_date, p.date_naissance))::int,
         to_char(p.date_naissance, 'MM-DD')
  from public.fans f
  join public.fans_prive p on p.fan_id = f.id
  where f.valide = true and p.date_naissance is not null;
$$;
revoke all on function public.fans_ages_anniv() from public;
grant execute on function public.fans_ages_anniv() to anon, authenticated;

--    b) pour un fan connecté : SA propre date complète (formulaire "Modifier mes infos")
create or replace function public.ma_date_naissance()
returns date
language sql
stable
security definer
set search_path = public
as $$
  select p.date_naissance
  from public.fans f
  join public.fans_prive p on p.fan_id = f.id
  where f.user_id = auth.uid()
  limit 1;
$$;
revoke all on function public.ma_date_naissance() from public;
grant execute on function public.ma_date_naissance() to authenticated;

-- 5) Règles de sécurité de la table "fans", remises au propre
alter table public.fans enable row level security;

do $$
declare r record;
begin
  for r in select policyname from pg_policies where tablename = 'fans' and schemaname = 'public' loop
    execute format('drop policy if exists %I on public.fans', r.policyname);
  end loop;
end $$;

-- lecture : fiches validées pour tous
create policy fans_lecture_publique on public.fans
  for select to anon, authenticated
  using (valide = true);

-- lecture : sa propre fiche (même non validée)
create policy fans_lecture_soi on public.fans
  for select to authenticated
  using (auth.uid() = user_id);

-- création : un fan connecté crée SA fiche
create policy fans_creation_soi on public.fans
  for insert to authenticated
  with check (auth.uid() = user_id);

-- modification : un fan connecté modifie SA fiche uniquement
create policy fans_modif_soi on public.fans
  for update to authenticated
  using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

-- modératrice : lecture, validation, refus, correction de toutes les fiches
create policy fans_admin_lecture on public.fans
  for select to authenticated
  using ((auth.jwt() ->> 'email') = 'elisabeth.sikora@orange.fr');

create policy fans_admin_modif on public.fans
  for update to authenticated
  using ((auth.jwt() ->> 'email') = 'elisabeth.sikora@orange.fr')
  with check (true);

create policy fans_admin_suppr on public.fans
  for delete to authenticated
  using ((auth.jwt() ->> 'email') = 'elisabeth.sikora@orange.fr');

-- 6) Vérification : doit afficher 0 (plus aucune date visible dans la table publique)
select count(*) as dates_encore_visibles from public.fans where date_naissance is not null;

-- ✅ Terminé.
