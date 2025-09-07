#!/bin/bash
echo "🏗️  Construction de l'image de production..."
docker-compose -f docker-compose.prod.yml build --no-cache web
echo "✅ Image de production construite !"
