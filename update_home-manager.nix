{ pkgs, system, self}: pkgs.writeShellApplication{
  name = "update-home";
    runtimeInputs = [ pkgs.git pkgs.lix pkgs.jq ];
    text = ''
      set -euo pipefail

      DOTFILES_DIR="$HOME/dotfiles"
      REPO_URL="https://github.com/rurou/dotfiles.git"
  
      show_pin() {
        jq -r '.nodes.nixpkgs.locked | .rev[:11] + " " + (.lastModified | todate)' flake.lock
      }     

      echo "🔍 Checking if $DOTFILES_DIR exists..."
      if [ ! -d "$DOTFILES_DIR" ]; then
        echo "📥 Cloning dotfiles repo into $DOTFILES_DIR..."
        git clone "$REPO_URL" "$DOTFILES_DIR"
      else
        echo "✅ $DOTFILES_DIR already exists."
      fi
  
      echo "📦 Changing to $DOTFILES_DIR..."
      cd "$DOTFILES_DIR"
      
      echo "✅ Checking flake..."
      nix flake check

      echo "📌 nixpkgs pin (before): $(show_pin)"

      echo "🔄 Updating flake.lock..."
      nix flake update

      echo "📌 nixpkgs pin (after):  $(show_pin)"

      echo "🏠 Applying home-manager config..."
      # ホスト名はいまの運用だと冗長なので削除
      # HOST=$(hostname)
      # FLAKE="${toString self}#$USER@$HOST"
      # FLAKE="${toString self}#$USER"
      # storeのpathを指定してしまってエラーが出たので修正
      FLAKE="$DOTFILES_DIR#$USER"
      
      echo "📦 Switching to flake: $FLAKE"
      if command -v home-manager >/dev/null 2>&1; then
        home-manager switch --flake "$FLAKE"
      else
      echo "📦 Install home-manager and switching to flake: $FLAKE"
        nix run github:nix-community/home-manager -- switch --flake "$FLAKE"
      fi

      echo "🔍 Checking git status..."
      cd "$(git rev-parse --show-toplevel)"

      if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
        echo "🔍 Git repository found, checking flake.lock changes..."
        if [ -n "$(git status --porcelain flake.lock)" ]; then
          git add flake.lock
          git commit -m "chore: flake update $(date +%Y-%m-%d) (nixpkgs $(jq -r '.nodes.nixpkgs.locked.rev[:11]' flake.lock))"
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
