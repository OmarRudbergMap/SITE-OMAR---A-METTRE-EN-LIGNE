# Guide d'intégration Supabase (pour le développeur)

Ce document explique comment relier le site `index.html` à Supabase.
Le site fonctionne aujourd'hui **en local** (mémoire du navigateur) ; le but est de
passer à une **base partagée** pour que tous les fans voient les mêmes données.

## 1. Mise en place
1. Créer un projet Supabase (offre gratuite).
2. Exécuter `schema.sql` (SQL Editor) pour créer les tables.
3. Activer l'authentification (email) si l'on veut des comptes fans.
4. Renseigner `config.js` (copie de `config.example.js`) avec l'URL + la clé anon.
5. Charger le client Supabase dans `index.html`, avant le script principal :
   ```html
   <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
   <script src="supabase/config.js"></script>
   <script>
     const sb = supabase.createClient(window.SUPABASE_URL, window.SUPABASE_ANON_KEY);
   </script>
   ```

## 2. Ce qu'il faut remplacer dans `index.html`
Le site utilise actuellement une base locale. Points d'entrée à rediriger vers Supabase :

- **Sauvegarde/chargement** : les fonctions `sauverBD()` / `chargerBD()` (et l'objet en mémoire)
  écrivent/lisent aujourd'hui en local → les faire écrire/lire dans les tables Supabase.
- **Carte des fans** : la liste des fans (points de la mappemonde) doit venir de la table `fans`
  (uniquement `valide = true`), au lieu des données de démonstration.
- **Photos** : lire/écrire la table `photos` ; upload de l'image vers **Supabase Storage**
  (bucket public `photos`), puis enregistrer l'URL renvoyée.
- **Vidéos** : enregistrer seulement le **lien** (YouTube/Instagram/TikTok) dans la table `videos`
  (aucun fichier vidéo stocké).
- **Votes (Awards)** : la logique « 1 vote par catégorie et par jour » existe déjà côté site
  (fonction `voterAward`, date via `aujourdhuiAw()`). La brancher sur la table `award_votes`
  (contrainte `unique(fan_id, categorie, jour)`), et afficher le **total** en lisant la somme
  des votes par catégorie (le site affiche déjà « Total : X votes »).
- **Modération** : n'afficher publiquement que les lignes `valide = true`.
  Prévoir un rôle modérateur pour passer `valide` à true.

## 3. Sécurité (RLS)
- Lecture publique du contenu **validé** uniquement.
- Écriture réservée aux fans authentifiés.
- Passage à `valide = true` réservé aux modérateurs (rôle dédié).
- Ne jamais exposer la clé « service_role » côté site.

## 4. Données personnelles / mineurs
- Respecter la page « Politique de confidentialité » du site.
- Conserver le `accord_parental` et permettre la **suppression** des données d'un fan sur demande.
