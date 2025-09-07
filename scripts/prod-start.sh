#!/bin/bash
echo "🚀 Démarrage de l'environnement de production..."
docker-compose -f docker-compose.prod.yml up -d
echo "✅ Environnement de production démarré !"
echo "📱 Application disponible sur: http://localhost:4000"
