#!/bin/bash
set -e

echo "🧹 Nettoyage complet des environnements Docker..."

# Arrêt et suppression complète des containers, réseaux et volumes DEV
echo "🛑 Arrêt de l'environnement DEV..."
docker-compose -f docker-compose.dev.yml down -v || echo "(Aucun container DEV à arrêter)"

# Arrêt et suppression complète des containers, réseaux et volumes PROD
echo "🛑 Arrêt de l'environnement PROD..."
docker-compose -f docker-compose.prod.yml down -v || echo "(Aucun container PROD à arrêter)"

# Nettoyage de tous les volumes Docker non utilisés
echo "🧽 Suppression des volumes Docker inutilisés..."
docker volume prune -f

# (Optionnel : suppression des networks non utilisés)
echo "🌐 Suppression des networks Docker inutilisés..."
docker network prune -f

echo "✅  Nettoyage complet ! Tu peux lancer ton nouvel environnement."
