
text
# 🚀 Phoenix Docker Template

Ce dépôt permet de démarrer n’importe quel projet Phoenix (Elixir) en mode containerisé **DEV/PROD** en quelques commandes.

---

## 👩‍💻 Création d’un nouveau projet

1. **Clone le template :**

git clone https://github.com/mon-org/phoenix-docker-template.git mon-super-app
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

---

> **Tu veux la version “template générateur” ? Viens demander : c’est possible, mais parfois plus complexe/long à maintenir pour des besoins internes courants.**

---
