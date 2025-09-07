#!/bin/bash
echo "🔄 Mise à jour forcée des dépendances..."
docker-compose -f docker-compose.dev.yml exec web rm -f /app/.deps_checksum
docker-compose -f docker-compose.dev.yml restart web
echo "✅ Dépendances mises à jour !"
