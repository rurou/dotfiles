#!/bin/bash

current=$(nix --version | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?")
latest=$(nix upgrade-nix --dry-run 2>&1 | grep -Eo "[0-9]+\.[0-9]+(\.[0-9]+)?")

echo "Current Nix version : $current"
echo "Latest Nix version  : $latest"

if [ "$current" != "$latest" ]; then
  echo "⚠️  Update available!"
else
  echo "✅ Nix is up to date."
fi

