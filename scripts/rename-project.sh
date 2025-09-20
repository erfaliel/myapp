#!/bin/bash
# Usage: ./scripts/rename-project.sh NewProjectName
set -e
OLD_NAME="hello" # Template app name (lowercase)
NEW_NAME="$1"

if [ -z "$NEW_NAME" ]; then
  echo "❌ Usage: $0 NewProjectName"
  exit 1
fi

OLD_MODULE="$(tr '[:lower:]' '[:upper:]' <<<${OLD_NAME:0:1})${OLD_NAME:1}" # Hello → Hello
NEW_MODULE="$(tr '[:lower:]' '[:upper:]' <<<${NEW_NAME:0:1})${NEW_NAME:1}" # test → Test

echo "🔄 Renaming project from $OLD_NAME/$OLD_MODULE to $NEW_NAME/$NEW_MODULE ..."

# 1. Update mix.exs (app name and module)
sed -i "s/app: :$OLD_NAME/app: :$NEW_NAME/" mix.exs
sed -i "s/$OLD_NAME/$NEW_NAME/g" mix.exs
sed -i "s/$OLD_MODULE/$NEW_MODULE/g" mix.exs

# 2. Update config files, scripts, README, docker-compose, .env files
for f in $(grep -rl "$OLD_NAME" config/ Dockerfile* docker-compose* scripts/ README* .env*); do
  sed -i "s/$OLD_NAME/$NEW_NAME/g" "$f"
done
for f in $(grep -rl "$OLD_MODULE" config/ Dockerfile* docker-compose* scripts/ README* .env*); do
  sed -i "s/$OLD_MODULE/$NEW_MODULE/g" "$f"
done

# 3. Rename Elixir library and test folders
[ -d "lib/$OLD_NAME" ] && mv "lib/$OLD_NAME" "lib/$NEW_NAME"
[ -d "test/$OLD_NAME" ] && mv "test/$OLD_NAME" "test/$NEW_NAME"

# 4. Optionally migrate main module in lib/
if [ -f "lib/${OLD_NAME}.ex" ]; then
  mv "lib/${OLD_NAME}.ex" "lib/${NEW_NAME}.ex"
  sed -i "s/$OLD_MODULE/$NEW_MODULE/g" "lib/${NEW_NAME}.ex"
fi

# 5. DEEP MODULE/FUNCTION RENAME in ALL .ex, .exs, .eex, .heex, .html files in lib/ test/ priv/
echo "📝 Deep renaming Hello/hello in source code ..."
find lib/ test/ priv/ -type f \( -name "*.ex" -o -name "*.exs" -o -name "*.eex" -o -name "*.heex" -o -name "*.html" \) | while read f; do
  sed -i "s/$OLD_MODULE/$NEW_MODULE/g" "$f" # Module names Hello → Test
  sed -i "s/$OLD_NAME/$NEW_NAME/g" "$f"     # Function names hello → test
done

echo "✅ Project successfully renamed to $NEW_NAME!"
echo "❗️Don't forget to review migrations, and replace all demo code with YOUR business logic."
