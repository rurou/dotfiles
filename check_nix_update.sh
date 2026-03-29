#!/bin/bash

# Lix 対応版バージョンチェック

# 現在のバージョン（"nix (Lix, like Nix) 2.95.1" から数値部分を抽出）
current=$(nix --version 2>&1 | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?" | head -1)

# Lix公式Giteaから最新タグを取得（APIで最新リリースを確認）
latest=$(curl -s "https://git.lix.systems/lix-project/lix/releases?limit=1" \
  | grep -Eo 'tag/[0-9]+\.[0-9]+(\.[0-9]+)?' \
  | head -1 \
  | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?")

# フォールバック: upgrade-nix --dry-run も試みる
if [ -z "$latest" ]; then
  latest=$(nix upgrade-nix --dry-run 2>&1 | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?" | tail -1)
fi

echo "Current Lix version : $current"
echo "Latest Lix version  : $latest"

if [ -z "$latest" ]; then
  echo "⚠️  Could not determine latest version."
elif [ "$current" != "$latest" ]; then
  echo "⚠️  Update available! ($current → $latest)"
else
  echo "✅ Lix is up to date."
fi

