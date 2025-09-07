---
# English
---

## 🚀 Phoenix Docker Template

This repository allows you to start any Phoenix (Elixir) project in a containerized DEV/PROD mode in just a few commands.

## 👩‍💻 Creating a New Project

Clone the template:

bash
git clone https://github.com/erfaliel/hello.git my-awesome-app
cd my-awesome-app
Rename the project (one time, irreversible):

bash
./scripts/rename-project.sh my_awesome_app
This will adapt all internal names (hello → my_awesome_app) for the app, config, modules, and scripts.

(Optional) Change the Phoenix or Elixir version

Change the version in mix.exs

Apply migration scripts if necessary

Launch migration:

bash
./scripts/phoenix-migrate.sh
Install dependencies and build the project (dev):

bash
./scripts/dev-rebuild.sh
Start DEV environment:

bash
./scripts/dev-start.sh
Your Phoenix app will be available on http://localhost:4000

## ⚙️ Useful Scripts

./scripts/dev-start.sh: start dev environment

./scripts/dev-stop.sh: stop dev

./scripts/dev-logs.sh: show dev logs

./scripts/dev-rebuild.sh: rebuild dev image

./scripts/phoenix-migrate.sh: major Phoenix config migration

./scripts/rename-project.sh <NAME>: project total rename

./scripts/clean-env.sh: clean environment when switching from dev to prod and vice versa

## 🏭 To create a new project from this template:

Clone this repo, rename, adapt, and… code at ease!
You benefit from the latest best practices in Docker, Phoenix, and CI/CD.
If the stack evolves, update this central repo — all your future projects will benefit.

## 🗃️ Updating the Template

When a new version of Phoenix/Elixir or your infra arrives:

Adjust this template,

Test it via a fresh project,

Push the “main” version to share with your team.

## 🏆 FAQ

Q: Can I run multiple projects on the same machine?
Yes, each clone is independent.

Q: What if I want to change the Docker image, Elixir base, or config?
Modify this template, then apply with “rename + dev-rebuild”.


## 🚀 Switching to Production
1. After Validating Your Application in Development
Once you have:

Coded and tested your project locally with

./scripts/dev-start.sh

Visited http://localhost:4000

And confirmed everything works as expected…

2. Prepare and Deploy the Production Environment
Clean-Up Step (Optional but Recommended)
Before deploying to production, make sure your environment is clean to prevent conflicts:

bash
./scripts/clean-env.sh
(This stops all DEV and PROD containers and prunes unused Docker volumes, ensuring a fresh start.)

Build the Production Image
bash
./scripts/prod-build.sh
(Rebuilds your production Docker image using Dockerfile.prod.)

Deploy the Production Environment
bash
./scripts/prod-deploy.sh
This script:

Automatically generates .env.prod with a secure secret key if missing

Rebuilds/relaunches all PROD containers (web & db) with their correct volumes

Waits for the database to be healthy, then checks if the app is running

Check That Everything Works
Open: http://localhost:4000

Your Phoenix app should work as it did in development, but now with the production configuration

To View Logs in Production
bash
./scripts/prod-logs.sh
(Shows the PRODUCTION container logs, for troubleshooting.)

To Stop Production Cleanly
bash
./scripts/prod-stop.sh
Quick FAQ
How do I switch back to development?

Stop prod: ./scripts/prod-stop.sh

(Optionally) Clean everything: ./scripts/clean-env.sh

Start dev: ./scripts/dev-start.sh

How do I reset everything for a fresh environment?
Run: ./scripts/clean-env.sh

Workflow Recap
bash
# Development
./scripts/dev-start.sh

# (code, test, debug...)

# (Optional) Clean up all before production
./scripts/clean-env.sh

# Switch to production
./scripts/prod-build.sh
./scripts/prod-deploy.sh

# (check http://localhost:4000)

--- 
# Français
--- 
## 🚀 Phoenix Docker Template

Ce dépôt permet de démarrer n’importe quel projet Phoenix (Elixir) en mode containerisé **DEV/PROD** en quelques commandes.

---

## 👩‍💻 Création d’un nouveau projet

1. **Clone le template :**

git clone https://github.com/erfaliel/hello.git mon-super-app
cd mon-super-app

text

2. **Renomme le projet (1x, irréversible) :**

./scripts/rename-project.sh mon_super_app

text

Cela va adapter tous les noms internes (`hello` → `mon_super_app`) pour l’application, la config, les modules et scripts.

3. **(Optionnel) Modifie la version Phoenix ou Elixir**
- Change la version dans `mix.exs`
- Applique les scripts de migration si nécessaires
- Lance :
  ```
  ./scripts/phoenix-migrate.sh
  ```

4. **Installe les dépendances et builder le projet (dev) :**
./scripts/dev-rebuild.sh

text

5. **Démarre l’environnement DEV :**
./scripts/dev-start.sh

text
L’application Phoenix sera disponible sur http://localhost:4000

---

## ⚙️ Script utiles

- `./scripts/dev-start.sh` : démarrage de l’environnement dev
- `./scripts/dev-stop.sh` : stop dev
- `./scripts/dev-logs.sh` : logs dev
- `./scripts/dev-rebuild.sh` : rebuild image dev
- `./scripts/phoenix-migrate.sh` : migration config Phoenix “majeure”
- `./scripts/rename-project.sh <NOM>` : rename total du projet
- ./scriopts/clean-env.sh : clean env when you quit dev env to prod env and viceversa

---
## 🏭 Pour créer un nouveau projet à partir de ce template :

- Clone ce repo, renomme, adapte et… code tranquille !
- Tu bénéficies des dernières bonnes pratiques Docker, Phoenix et CI/CD.
- Si la stack évolue, tu mets à jour ce repo central : tous tes prochains projets en profitent.

---

## 🗃️ Mise à jour du template

Quand une nouvelle version de Phoenix/Elixir ou de ton infra arrive :
- Ajuste ce template,
- Teste-le via un projet vierge,
- Pousse la version “main” à partager avec l’équipe.

---

## 🏆 FAQ

*Q: Puis-je lancer plusieurs projets sur la même machine ?*
- Oui, chaque clone est indépendant.

*Q: Que faire si je veux changer d’image Docker, de base Elixir, ou de config ?*
- Modifie ce template, puis applique par “rename + dev-rebuild”.

🚀 Passer à la production
1. Après validation de ton application en développement
Lorsque tu as :

codé et testé localement avec :

./scripts/dev-start.sh

http://localhost:4000

validé que tout fonctionne comme attendu…

2. Prépare et déploie l’environnement de production
Nettoyage préalable (optionnel mais recommandé)
Avant tout déploiement prod, assure-toi que l’environnement est propre :

bash
./scripts/clean-env.sh
(Cela arrête tous les containers DEV et PROD et nettoie les volumes Docker inutilisés pour éviter tout conflit.)

Build l’image de production
bash
./scripts/prod-build.sh
(Reconstruit l’image Docker de production selon le Dockerfile.prod.)

Déploie l’environnement de production
bash
./scripts/prod-deploy.sh
Ce script :

Génère automatiquement .env.prod avec une clé secrète robuste si besoin

Reconstruit/relance tous les containers PROD (web & bdd), applique les bons volumes

Attends la santé de la bdd puis vérifie que l’appli est bien en ligne

Vérifie que tout fonctionne
Ouvre : http://localhost:4000

Tout doit fonctionner de la même manière qu’en dev, mais avec les réglages de sécurité/performances de la prod

Pour surveiller les logs en production :
bash
./scripts/prod-logs.sh
(Affiche les journals des containers PROD pour troubleshooting.)

Pour arrêter la prod proprement :
bash
./scripts/prod-stop.sh
FAQ rapide
Et si j’ai besoin de repasser en dev ?

Stoppe la prod (./scripts/prod-stop.sh)

Nettoie (optionnel) (./scripts/clean-env.sh)

Lance le dev (./scripts/dev-start.sh)

Comment réinitialiser un environnement tout propre avant test ?
./scripts/clean-env.sh

Récapitulatif du workflow
text
# Dev
./scripts/dev-start.sh

# (tests, dev, debug...)

# Clean-up avant prod (optionnel mais recommandé)
./scripts/clean-env.sh

# Passage en prod
./scripts/prod-build.sh
./scripts/prod-deploy.sh

# (vérif sur http://localhost:4000)

