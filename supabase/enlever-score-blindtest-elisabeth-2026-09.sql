-- Enlever le score de blind test d'Elisabeth pour l'édition de septembre (2026-09)
-- pour lui permettre de rejouer.
-- À lancer dans Supabase → SQL Editor (projet hdxrajqcawqhpmqypujz).
delete from public.blindtest_scores
where user_id = 'cefd64a2-c488-4b8d-8bb2-b9fb244ce1ba'
  and edition = '2026-09';
