#!/bin/bash
echo "🛑 Arrêt de l'environnement de production..."
docker-compose -f docker-compose.prod.yml down
echo "✅ Environnement de production arrêté !"
