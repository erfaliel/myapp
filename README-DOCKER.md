text
# 🐳 Développement avec Docker

## Démarrage Rapide

Premier démarrage / Après une mise à jour majeure
./scripts/dev-rebuild.sh
Démarrage normal
./scripts/dev-start.sh
Voir les logs
./scripts/dev-logs.sh
Arrêter l'environnement
./scripts/dev-stop.sh
text

## URLs Utiles

- 📱 **Application**: http://localhost:4000
- 📊 **Dashboard**: http://localhost:4000/dev/dashboard
- 🗄️ **Base de données**: localhost:5432

## Comment ça Marche ?

Le système détecte automatiquement les changements de `mix.lock` et met à jour les dépendances au démarrage du conteneur. Plus besoin de commandes manuelles !

## En cas de Problème

Si quelque chose ne fonctionne pas :

Reconstruction complète
./scripts/dev-rebuild.sh
Si ça ne marche toujours pas
docker-compose -f docker-compose.dev.yml down -v
./scripts/dev-rebuild.sh


## Workflow Recommandé
Pour les mises à jour majeures comme Phoenix :
Modifiez mix.exs avec la nouvelle version
`./scripts/dev-start.sh → Le script détecte et met à jour automatiquement`
Testez votre application
Pour forcer une mise à jour :

`./scripts/dev-update-deps.sh`
