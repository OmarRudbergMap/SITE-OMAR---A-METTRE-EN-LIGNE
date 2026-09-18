-- Enlever le score de blind test d'Elisabeth pour l'édition de septembre 2026 (16 pts)
-- À exécuter dans Supabase (projet hdxrajqcawqhpmqypujz) > SQL Editor.
-- Cela supprime UNIQUEMENT cette ligne (édition 2026-09 d'Elisabeth), rien d'autre.

delete from blindtest_scores
where user_id = 'cefd64a2-c488-4b8d-8bb2-b9fb244ce1ba'
  and edition = '2026-09';

-- Vérification (doit renvoyer 0 ligne pour septembre après le delete) :
-- select edition, score from blindtest_scores
-- where user_id = 'cefd64a2-c488-4b8d-8bb2-b9fb244ce1ba';
