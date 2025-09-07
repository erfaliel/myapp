#!/bin/bash
echo "📋 Affichage des logs de production..."
docker-compose -f docker-compose.prod.yml logs -f web
