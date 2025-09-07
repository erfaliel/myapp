#!/bin/sh

echo "🚀 Démarrage de l'application Phoenix en production..."

# En production, on vérifie d'abord que la release est correcte
if [ ! -f "./bin/hello" ]; then
  echo "❌ Erreur: Release non trouvée. Reconstruisez l'image Docker."
  exit 1
fi

# Création de la base de données si nécessaire
echo "🗄️  Création de la base de données si nécessaire..."
./bin/hello eval "Hello.Release.create_db()"

# Exécution des migrations
echo "🔄 Exécution des migrations de base de données..."
./bin/hello eval "Hello.Release.migrate()"

echo "✅ Base de données prête pour l'application"

echo "🎯 Lancement de l'application en production..."
exec ./bin/hello start
