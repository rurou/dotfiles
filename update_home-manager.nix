{ pkgs, system, self}: pkgs.writeShellApplication{
  name = "update-home";
    runtimeInputs = [ pkgs.git pkgs.nix ];
    text = ''
      set -euo pipefail

      echo "✅ Checking flake..."
      nix flake check

      echo "🔄 Updating flake.lock..."
      nix flake update

      echo "🏠 Applying home-manager config..."
      HOST=$(hostname)
      FLAKE="${self}#$USER@$HOST"
      
      echo "📦 Switching to flake: $FLAKE"
      home-manager switch --flake "$FLAKE"

      echo "🔍 Checking git status..."
      # cd ${toString self}
      cd "$(git rev-parse --show-toplevel)"

      if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "🔍 Git repository found, checking flake.lock changes..."
        if [ -n "$(git status --porcelain flake.lock)" ]; then
          git add flake.lock
          git commit -m "chore: flake update $(date +%Y-%m-%d)"
          git push
          echo "✅ Changes committed & pushed."
        else
          echo "✅ No changes to commit."
        fi
      else
        echo "⚠️ Not in a Git repository, skipping commit/push step."
      fi
    '';
}
