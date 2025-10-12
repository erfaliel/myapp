#!/bin/bash
# Usage: ./scripts/rename-project.sh NewProjectName
set -e

# CONFIGURATION: Current template names (UPDATE THESE FOR YOUR TEMPLATE)
OLD_APP_ATOM="hello"           # Atom in mix.exs :hello
OLD_APP_LOWER="hello"          # Lowercase app name
OLD_APP_UPPER="Hello"          # Capitalized module name
OLD_APP_WEB="hello_web"        # Web module lowercase
OLD_APP_WEB_UPPER="HelloWeb"   # Web module capitalized
OLD_DB_NAME="hello_dev"        # Database name

NEW_NAME="$1"

if [ -z "$NEW_NAME" ]; then
  echo "❌ Usage: $0 NewProjectName"
  echo "   Example: ./scripts/rename-project.sh myapp"
  echo ""
  echo "📋 Current template configuration:"
  echo "   App atom: :$OLD_APP_ATOM"
  echo "   Module: $OLD_APP_UPPER"
  echo "   Web module: ${OLD_APP_WEB_UPPER}"
  exit 1
fi

# Generate all variations of the new name
NEW_APP_LOWER=$(echo "$NEW_NAME" | tr '[:upper:]' '[:lower:]')      # myapp
NEW_APP_UPPER="$(echo ${NEW_APP_LOWER:0:1} | tr '[:lower:]' '[:upper:]')${NEW_APP_LOWER:1}"  # Myapp
NEW_APP_WEB="${NEW_APP_LOWER}_web"                                # myapp_web
NEW_APP_WEB_UPPER="${NEW_APP_UPPER}Web"                           # MyappWeb
NEW_DB_NAME="${NEW_APP_LOWER}_dev"                                # myapp_dev

echo "🔄 Renaming project from $OLD_APP_LOWER/$OLD_APP_UPPER to $NEW_APP_LOWER/$NEW_APP_UPPER ..."
echo "📊 Summary of changes:"
echo "   :$OLD_APP_ATOM → :$NEW_APP_LOWER"
echo "   $OLD_APP_UPPER → $NEW_APP_UPPER"
echo "   $OLD_APP_WEB_UPPER → $NEW_APP_WEB_UPPER"
echo "   $OLD_DB_NAME → $NEW_DB_NAME"
echo ""

# Function to replace all patterns in a file
replace_patterns_in_file() {
  local file="$1"
  if [ -f "$file" ]; then
    echo "    - Updating $file"
    # Replace all variations systematically
    sed -i '' "s/:$OLD_APP_ATOM/:$NEW_APP_LOWER/g" "$file"              # :hello -> :myapp
    sed -i '' "s/app: :$OLD_APP_ATOM/app: :$NEW_APP_LOWER/g" "$file"    # app: :hello -> app: :myapp
    sed -i '' "s/$OLD_APP_UPPER\\.$OLD_APP_UPPER/$NEW_APP_UPPER.$NEW_APP_UPPER/g" "$file"  # Hello.Hello -> Myapp.Myapp
    sed -i '' "s/$OLD_APP_WEB_UPPER/$NEW_APP_WEB_UPPER/g" "$file"        # HelloWeb -> MyappWeb
    sed -i '' "s/$OLD_APP_UPPER/$NEW_APP_UPPER/g" "$file"                # Hello -> Myapp
    sed -i '' "s/$OLD_APP_WEB/$NEW_APP_WEB/g" "$file"                    # hello_web -> myapp_web
    sed -i '' "s/$OLD_APP_LOWER/$NEW_APP_LOWER/g" "$file"                # hello -> myapp
    sed -i '' "s/$OLD_DB_NAME/$NEW_DB_NAME/g" "$file"                    # hello_dev -> myapp_dev
    # Special cases for build commands
    sed -i '' "s/esbuild $OLD_APP_LOWER/esbuild $NEW_APP_LOWER/g" "$file"
    sed -i '' "s/tailwind $OLD_APP_LOWER/tailwind $NEW_APP_LOWER/g" "$file"
  fi
}

# 1. Update mix.exs
echo "  📝 Updating mix.exs..."
replace_patterns_in_file "mix.exs"

# 2. Update ALL configuration files
echo "  📝 Updating configuration files..."
for f in config/*.exs; do
  replace_patterns_in_file "$f"
done

# 3. Update Docker, README, and environment files
echo "  📝 Updating Docker, README and environment files..."
for f in Dockerfile* docker-compose* README* .env*; do
  if [ -f "$f" ] && [ "$f" != "scripts/rename-project.sh" ]; then
    replace_patterns_in_file "$f"
  fi
done

# 4. Update scripts (but exclude this rename script)
echo "  📝 Updating script files..."
for f in scripts/*.sh; do
  if [ -f "$f" ] && [[ "$f" != *"rename-project.sh" ]]; then
    replace_patterns_in_file "$f"
  fi
done

# 5. Rename directories
echo "  📝 Renaming directories..."
if [ -d "lib/$OLD_APP_LOWER" ]; then
  echo "    - Renaming lib/$OLD_APP_LOWER to lib/$NEW_APP_LOWER"
  mv "lib/$OLD_APP_LOWER" "lib/$NEW_APP_LOWER"
fi
if [ -d "lib/$OLD_APP_WEB" ]; then
  echo "    - Renaming lib/$OLD_APP_WEB to lib/$NEW_APP_WEB"
  mv "lib/$OLD_APP_WEB" "lib/$NEW_APP_WEB"
fi
if [ -d "test/$OLD_APP_LOWER" ]; then
  echo "    - Renaming test/$OLD_APP_LOWER to test/$NEW_APP_LOWER"
  mv "test/$OLD_APP_LOWER" "test/$NEW_APP_LOWER"
fi

# 6. Rename main application file
if [ -f "lib/${OLD_APP_LOWER}.ex" ]; then
  echo "    - Renaming lib/${OLD_APP_LOWER}.ex to lib/${NEW_APP_LOWER}.ex"
  mv "lib/${OLD_APP_LOWER}.ex" "lib/${NEW_APP_LOWER}.ex"
fi

# 7. Update ALL source code files
echo "  📝 Updating source code files..."
find lib/ test/ priv/ assets/ -type f \( -name "*.ex" -o -name "*.exs" -o -name "*.eex" -o -name "*.heex" -o -name "*.html" -o -name "*.js" \) 2>/dev/null | while read f; do
  replace_patterns_in_file "$f"
done

# 8. Update Tailwind config specifically
if [ -f "assets/tailwind.config.js" ]; then
  echo "  📝 Updating Tailwind configuration..."
  replace_patterns_in_file "assets/tailwind.config.js"
fi

echo "✅ Project successfully renamed to $NEW_NAME!"
echo "❗️Don't forget to review migrations, and replace all demo code with YOUR business logic."
