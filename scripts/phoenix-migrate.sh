#!/bin/bash
set -e

TARGET_VERSION="1.8.0"

echo "🔎 Migration automatique de la config Phoenix pour la version $TARGET_VERSION"

# Mise à jour de la ligne Phoenix dans mix.exs
echo "📝 Mise à jour de la ligne de dépendance Phoenix si besoin"
if [[ "$OSTYPE" == "darwin"* ]]; then
  sed -i '' "s/{:phoenix, \"~> [0-9.]*\"}/{:phoenix, \"~> $TARGET_VERSION\"}/" mix.exs
else
  sed -i "s/{:phoenix, \"~> [0-9.]*\"}/{:phoenix, \"~> $TARGET_VERSION\"}/" mix.exs
fi

# Ajout automatique du listener si manquant
echo "🔧 Vérification de la configuration listeners..."
if ! grep -q "listeners.*Phoenix.CodeReloader" mix.exs; then
  if [[ "$OSTYPE" == "darwin"* ]]; then
    sed -i '' '/def project do/,/]/ s/deps: deps()/deps: deps(),\
      listeners: [Phoenix.CodeReloader]/' mix.exs
  else
    sed -i '/def project do/,/]/ s/deps: deps()/deps: deps(),\
      listeners: [Phoenix.CodeReloader]/' mix.exs
  fi
  echo "✅ Ajout de listeners: [Phoenix.CodeReloader] dans la config project"
else
  echo "✅ Les listeners Phoenix.CodeReloader sont déjà présents"
fi

echo "🔄 Reconstruction du projet..."
./scripts/dev-rebuild.sh

echo "✅ Migration automatique terminée !"
