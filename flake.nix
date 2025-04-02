{
  description = "Home Manager configuration of rurou";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-flake = {
      url = "github:konradmalik/neovim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, neovim-flake, neovim-nightly-overlay, nixvim, ... }@inputs:
    let
      system = "aarch64-darwin";
      pkgs = nixpkgs.legacyPackages.${system};

      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
    in {
      homeConfigurations."rurou" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home/mac.nix
          neovim-flake.homeManagerModules.default
          {
            nixpkgs.overlays = overlays;
          }
          nixvim.homeManagerModules.nixvim
        ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
      };
        # 既存の homeConfigurations などはそのまま

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.setup-dotfiles}/bin/setup-dotfiles";
      };

      packages.${system}.setup-dotfiles = pkgs.writeShellScriptBin {
        name = "setup-dotfiles";
        runtimeInputs = [ home-manager ];
        text = ''
          #!${pkgs.bash}/bin/bash
          echo "▶️ Running dotfiles setup..."

          # ホスト名に合わせてhome-configを切り替える（例: rurou@MacBook-Air.local）
          USER=$(whoami)
          HOST=$(scutil --get LocalHostName) # Mac向け
          FLAKE="${PWD}#${USER}@${HOST}"

          echo "📦 Switching to flake: $FLAKE"
          home-manager switch --flake "$FLAKE"
        '';
      };
    };
}
