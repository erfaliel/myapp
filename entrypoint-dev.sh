#!/bin/sh

echo "🔄 Vérification des dépendances Phoenix..."

# Calcule les checksums des fichiers de dépendances
MIX_EXS_CHECKSUM=$(md5sum mix.exs 2>/dev/null | cut -d' ' -f1 || echo "none")
MIX_LOCK_CHECKSUM=$(md5sum mix.lock 2>/dev/null | cut -d' ' -f1 || echo "none")
COMBINED_CHECKSUM="${MIX_EXS_CHECKSUM}_${MIX_LOCK_CHECKSUM}"

CACHE_FILE="/app/.deps_checksum"
CACHED_CHECKSUM=$(cat "$CACHE_FILE" 2>/dev/null || echo "none")

# Force la mise à jour si les fichiers ont changé OU si mix deps.get échoue
need_update=false

if [ "$CACHED_CHECKSUM" != "$COMBINED_CHECKSUM" ]; then
  echo "📦 Changement détecté dans mix.exs ou mix.lock..."
  need_update=true
else
  # Test si les dépendances sont cohérentes
  echo "🔍 Vérification de la cohérence des dépendances..."
  if ! mix deps.check --quiet >/dev/null 2>&1; then
    echo "⚠️  Incohérence détectée entre mix.exs et les dépendances installées..."
    need_update=true
  fi
fi

if [ "$need_update" = true ]; then
  echo "⏳ Mise à jour des dépendances en cours..."

  # Mise à jour et installation des dépendances
  mix deps.get

  # Compilation des dépendances
  echo "⏳ Compilation des dépendances..."
  mix deps.compile

  # Sauvegarde du nouveau checksum
  echo "$COMBINED_CHECKSUM" >"$CACHE_FILE"
  echo "✅ Dépendances mises à jour avec succès !"
else
  echo "✅ Dépendances déjà à jour et cohérentes"
fi

echo "🚀 Démarrage de Phoenix..."
exec mix phx.server
