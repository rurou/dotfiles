{
  outputs = { self, nixpkgs, home-manager, ... }@inputs: let
    systems = [ "x86_64-linux" "aarch64-darwin" ];

    mkApp = system: let
      pkgs = nixpkgs.legacyPackages.${system};
      updater = pkgs.writeShellApplication {
        name = "update-home";
        runtimeInputs = [ pkgs.git pkgs.nix ];
        text = ''
          set -euo pipefail

          echo "✅ Checking flake..."
          nix flake check

          echo "🔄 Updating flake.lock..."
          nix flake update

          echo "🏠 Applying home-manager config..."
          nix run .#homeConfigurations.$USER@${system}.activationPackage

          echo "🔍 Checking git status..."
          cd ${toString self}
          if [ -n "$(git status --porcelain flake.lock)" ]; then
            git add flake.lock
            git commit -m "chore: flake update $(date +%Y-%m-%d)"
            git push
            echo "✅ Changes committed & pushed."
          else
            echo "✅ No changes to commit."
          fi
        '';
      };
    in {
      type = "app";
      program = "${updater}/bin/update-home";
    };
  in {
    apps = builtins.listToAttrs (map (system: {
      name = "${system}.update-home";
      value = mkApp system;
    }) systems);
  };
}
