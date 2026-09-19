-- ============================================================
--  CORRECTION : autoriser les DEMI-POINTS dans le quiz
--  Problème : la colonne "points" de quiz_progression était en ENTIER,
--  donc un score comme 8.5 (bonus photo Young Royals +0,5) était REFUSÉ
--  → l'enregistrement échouait ("invalid input syntax for type integer: 8.5").
--  Solution : passer la colonne en nombre décimal (numeric).
--  À exécuter UNE fois dans Supabase (projet hdxrajqcawqhpmqypujz) > SQL Editor.
-- ============================================================

alter table public.quiz_progression
  alter column points type numeric using points::numeric;

alter table public.quiz_progression
  alter column points set default 0;

-- Vérification (facultatif) : le type doit maintenant être "numeric"
-- select column_name, data_type from information_schema.columns
-- where table_name = 'quiz_progression' and column_name = 'points';
