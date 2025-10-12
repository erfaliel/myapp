#!/bin/bash
echo "🚀 Déploiement en production..."
echo "🚀 Déploiement en production..."

# Génère .env.prod s'il n'existe pas
if [ ! -f ".env.prod" ]; then
  echo "📝 Génération du fichier .env.prod..."

  # Génère une clé secrète
  # SECRET_KEY=$(openssl rand -base64 64 | tr -d '\n')
  SECRET_KEY=$(openssl rand -base64 48 | tr -d '\n')
  cat >.env.prod <<EOF
# Environnement de production
SECRET_KEY_BASE=$SECRET_KEY
MIX_ENV=prod
DATABASE_URL=ecto://postgres:postgres@db/test_prod
PHX_HOST=localhost
PORT=4000
DEBUG=false
EOF

  echo "✅ Fichier .env.prod généré avec une clé secrète unique"
fi
echo "🛑 Arrêt de l'environnement existant..."
docker-compose -f docker-compose.prod.yml down

echo "🏗️  Construction de la nouvelle image..."
docker-compose -f docker-compose.prod.yml build --no-cache web

echo "🚀 Démarrage du nouvel environnement..."
docker-compose -f docker-compose.prod.yml up -d

echo "⏳ Attente du démarrage..."
sleep 10

echo "🔍 Vérification du statut..."
if docker-compose -f docker-compose.prod.yml ps --services --filter "status=running" | grep -q web; then
  echo "✅ Déploiement réussi !"
  echo "📱 Application disponible sur: http://localhost:4000"
else
  echo "❌ Problème de déploiement, vérifiez les logs:"
  docker-compose -f docker-compose.prod.yml logs web
fi
