# Omar Rudberg World Map — site

Site de fans (site partenaire de l'O.R. World Association, pas l'association elle-même).
Prévu pour être hébergé sur **Netlify** et, plus tard, relié à **Supabase** (base de données partagée).

---

## 📁 Structure du dossier

```
omarrudbergmap/
├── index.html          ← le site (une seule page, tout est dedans)
├── photos/             ← toutes les photos .webp des fans/concerts
├── videos/             ← toutes les vidéos .mp4 (galeries de concerts)
├── netlify.toml        ← réglage d'hébergement Netlify
├── .gitignore          ← fichiers à ne pas publier
└── supabase/           ← préparation de la base de données (pour le développeur)
    ├── schema.sql
    ├── config.example.js
    └── GUIDE-INTEGRATION.md
```

> ⚠️ **Important — les photos et vidéos ne sont PAS incluses ici.**
> Elles sont trop lourdes (~3 Go). Tu les as déjà toutes dans tes téléchargements.
> Il faut simplement les ranger toi-même :
> - tous les fichiers **`.webp`** → dans le dossier **`photos/`**
> - tous les fichiers **`.mp4`** (sauf ceux finissant par `_src`) → dans le dossier **`videos/`**
>
> Le fichier `index.html` cherche les images à `photos/NOM.webp` et les vidéos à `videos/NOM.mp4`.
> Il faut donc que les noms soient exacts et que les fichiers soient bien dans ces deux dossiers.

---

## 🚀 Mettre le site en ligne — 2 options

### Option A (la plus simple, sans GitHub) : Netlify Drop
1. Range `index.html` + les dossiers `photos/` et `videos/` dans un seul dossier.
2. Va sur https://app.netlify.com/drop et **glisse le dossier entier**.
3. C'est en ligne. Branche ensuite ton domaine `omarrudbergmap.com` (voir le guide).

### Option B : GitHub + Netlify (si tu préfères GitHub)
1. Crée un compte sur https://github.com puis un nouveau dépôt (**New repository**), par ex. `omarrudbergmap`.
2. Envoie ce dossier dans le dépôt :
   - le plus simple sans logiciel : bouton **« Add file » → « Upload files »** sur GitHub, puis glisse les fichiers.
   - ⚠️ GitHub limite chaque fichier à 100 Mo (tes fichiers passent), mais **~3 Go de médias dans un dépôt, c'est lourd**. Pour un vrai confort, l'idéal (plus tard) est de déplacer les médias vers un stockage (Supabase Storage / Cloudflare R2) et de garder les vidéos en **liens YouTube/Instagram/TikTok**.
3. Sur Netlify : **Add new site → Import an existing project → GitHub** → choisis ton dépôt.
4. Réglage de publication : dossier racine `/` (rien à compiler). Déploie.
5. Branche ton domaine `omarrudbergmap.com`.

---

## 🧠 Supabase (base de données partagée) — état actuel

**À ce stade, le site fonctionne seul (chaque visiteur a ses données en local).**
La connexion à Supabase (carte commune, votes communs, photos partagées) **reste à coder** : c'est l'étape « développeur ».

Le dossier `supabase/` contient tout le nécessaire pour démarrer cette étape :
- `schema.sql` : les tableaux de la base (fans, photos, vidéos, votes) à créer en un clic dans Supabase.
- `config.example.js` : le modèle où mettre TES clés Supabase.
- `GUIDE-INTEGRATION.md` : la marche à suivre pour la personne qui code.

---

## ✅ Ce que tu peux faire seule
- Ranger les photos/vidéos, déployer sur Netlify, brancher le domaine, créer le compte + la base Supabase.

## 🔧 Ce qui demande un développeur
- Relier le site à Supabase (carte, photos, votes en temps réel partagés).

Ensemble, faisons rayonner Omar partout dans le monde. 🌍❤️
