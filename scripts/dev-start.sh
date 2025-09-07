#!/bin/bash
echo "🚀 Démarrage de l'environnement de développement Phoenix..."
docker-compose -f docker-compose.dev.yml up -d
echo "✅ Environnement démarré !"
echo "📱 Application disponible sur: http://localhost:4000"
echo "📊 Dashboard disponible sur: http://localhost:4000/dev/dashboard"
