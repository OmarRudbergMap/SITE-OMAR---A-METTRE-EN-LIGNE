-- ============================================================
--  DÉBLOQUER LE COMPTE D'UNE FAN — version améliorée
--
--  👉 Remplace les 2 textes en MAJUSCULES, puis Run.
--     - MOT_DE_PASSE_PROVISOIRE = un mot de passe que TU choisis (≥ 8 lettres/chiffres,
--       SANS espace, SANS accent). Tu le donnes à la fan.
--     - EMAIL_DE_LA_FAN = son e-mail (ici la casse majuscule/minuscule n'a plus d'importance)
-- ============================================================

update auth.users
set encrypted_password = crypt('MOT_DE_PASSE_PROVISOIRE', gen_salt('bf')),
    email_confirmed_at   = coalesce(email_confirmed_at, now())
where lower(email) = lower('EMAIL_DE_LA_FAN')
returning email, email_confirmed_at, last_sign_in_at;

-- ============================================================
--  COMMENT LIRE LE RÉSULTAT (en bas de l'écran après Run) :
--
--  • Une LIGNE apparaît avec l'e-mail  → ✅ le mot de passe est bien changé.
--      La fan peut se connecter avec cet e-mail + le mot de passe provisoire.
--
--  • « Success. No rows returned » / AUCUNE ligne → ❗ ce compte n'existe pas.
--      La fan n'a jamais eu de compte : il faut le CRÉER (voir le message de Claude :
--      Authentication > Users > Add user > Auto Confirm User).
--
--  • Erreur « function crypt(...) does not exist » → lance D'ABORD la ligne ci-dessous
--      une seule fois, puis relance la requête du haut :
--        create extension if not exists pgcrypto with schema extensions;
-- ============================================================
