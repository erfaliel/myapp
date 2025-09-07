#!/bin/bash
echo "📋 Affichage des logs du conteneur web..."
docker-compose -f docker-compose.dev.yml logs -f web
