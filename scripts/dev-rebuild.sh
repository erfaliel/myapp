#!/bin/bash
echo "🔄 Reconstruction complète de l'environnement..."
echo "🛑 Arrêt des conteneurs..."
docker-compose -f docker-compose.dev.yml down

echo "🏗️  Reconstruction de l'image (sans cache)..."
docker-compose -f docker-compose.dev.yml build --no-cache web

echo "🚀 Redémarrage de l'environnement..."
docker-compose -f docker-compose.dev.yml up -d

echo "✅ Reconstruction terminée !"
echo "📱 Application disponible sur: http://localhost:4000"
