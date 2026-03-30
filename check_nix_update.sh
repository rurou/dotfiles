#!/bin/bash
# Lix バージョンチェック

current=$(nix --version 2>&1 | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1)

latest=$(curl -s "https://git.lix.systems/api/v1/repos/lix-project/lix/tags?limit=1" \
  | python3 -c "import sys,json; print(json.load(sys.stdin)[0]['name'])" 2>/dev/null)

echo "Current Lix version : $current"
echo "Latest Lix version  : $latest"

if [ -z "$latest" ]; then
  echo "⚠️  Could not determine latest version."
  exit 1
fi

verlte() {
  [ "$1" = "$(printf '%s\n' "$1" "$2" | sort -V | head -1)" ]
}

if [ "$current" = "$latest" ]; then
  echo "✅ Lix is up to date."
elif verlte "$latest" "$current"; then
  echo "✅ Lix is newer than latest release (dev build?)."
else
  echo "⚠️  Update available! ($current → $latest)"
fi

