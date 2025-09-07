#!/bin/bash
# Usage : ./scripts/rename-project.sh NouveauNomProjet

set -e

OLD_NAME="hello" # Nom de base de ton template (important)
NEW_NAME="$1"

if [ -z "$NEW_NAME" ]; then
  echo "❌ Usage: $0 NouveauNomProjet"
  exit 1
fi

echo "🔄 Renommage du projet $OLD_NAME → $NEW_NAME..."

## 1. Renommage mix.exs (nom module + app)
sed -i "s/app: :$OLD_NAME/app: :$NEW_NAME/" mix.exs
sed -i "s/$OLD_NAME/$NEW_NAME/g" mix.exs
sed -i "s/${OLD_NAME^}/${NEW_NAME^}/g" mix.exs # Capitalized pour module

## 2. Renommage fichiers config, scripts, README, docker-compose
for f in $(grep -rl "$OLD_NAME" config/ Dockerfile* docker-compose* scripts/ README* .env*); do
  sed -i "s/$OLD_NAME/$NEW_NAME/g" "$f"
done

for f in $(grep -rl "${OLD_NAME^}" config/ Dockerfile* docker-compose* scripts/ README* .env*); do
  sed -i "s/${OLD_NAME^}/${NEW_NAME^}/g" "$f"
done

## 3. Renommage des dossiers Elixir
[ -d "lib/$OLD_NAME" ] && mv "lib/$OLD_NAME" "lib/$NEW_NAME"
[ -d "test/$OLD_NAME" ] && mv "test/$OLD_NAME" "test/$NEW_NAME"

## 4. Option : Migration du module principal dans lib/
if [ -f "lib/${OLD_NAME}.ex" ]; then
  mv "lib/${OLD_NAME}.ex" "lib/${NEW_NAME}.ex"
  sed -i "s/${OLD_NAME^}/${NEW_NAME^}/g" "lib/${NEW_NAME}.ex"
fi

## 5. Optionnel : renommer le dossier principal si besoin (manuellement/déploiement, pas toujours souhaitable)
# cd ..
# mv "$OLD_NAME" "$NEW_NAME"
# cd "$NEW_NAME"

echo "✅ Projet renommé : $NEW_NAME !"

echo "❗️ N'oublie pas de tester les migrations et de remplacer tout le code de démo par TON code métier."
