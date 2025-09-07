#!/bin/bash
echo "🛑 Arrêt de l'environnement de développement..."
docker-compose -f docker-compose.dev.yml down
echo "✅ Environnement arrêté !"
