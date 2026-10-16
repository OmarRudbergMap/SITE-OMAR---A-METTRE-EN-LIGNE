-- ============================================================
--  DÉBLOQUER LE COMPTE D'UNE FAN — méthode sûre en 2 étapes
--  (le compte EXISTE déjà, on lui remet juste un mot de passe)
-- ============================================================

-- ÉTAPE 1 — RETROUVER le compte.
--   Remplace MORCEAU_DU_MAIL par un bout de son e-mail (ex. le nom avant @),
--   puis Run. Une ou plusieurs lignes vont apparaître en bas.
--   Repère la bonne, et COPIE la valeur de la colonne "id"
--   (ça ressemble à : 3f9a1c2b-6d4e-47aa-9b1c-8e2f1a2b3c4d)

select id, email, email_confirmed_at, last_sign_in_at
from auth.users
where email ilike '%MORCEAU_DU_MAIL%';


-- ÉTAPE 2 — REMETTRE le mot de passe.
--   Colle l'id copié à la place de COLLE_L_ID_ICI (garde les guillemets),
--   mets ton mot de passe (tes 6 chiffres) à la place de MOT_DE_PASSE,
--   puis Run. Une ligne avec l'e-mail doit apparaître = c'est bon ✅

update auth.users
set encrypted_password = crypt('MOT_DE_PASSE', gen_salt('bf')),
    email_confirmed_at   = coalesce(email_confirmed_at, now())
where id = 'COLLE_L_ID_ICI'
returning email, email_confirmed_at;

-- (Si un jour l'erreur « function crypt(...) does not exist » apparaît,
--  lance d'abord une seule fois :
--    create extension if not exists pgcrypto with schema extensions;  )
