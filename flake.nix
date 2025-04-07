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
      username = "rurou";
      hostname = "MacBook-Air.local";
    in {
      homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
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
        extraSpecialArgs = {
          inherit username hostname;
          inherit (inputs) home-manager;
        };
      };
        # 既存の homeConfigurations などはそのまま

      apps.${system}.default = {
        type = "app";
        program = "${self.packages.${system}.setup-dotfiles}/bin/update-home";
      };

      packages.${system}.update-home = pkgs.writeShellApplication {
        name = "update-home";
        runtimeInputs = [ home-manager ];
        text = ''
          echo "▶️ Running dotfiles setup..."

          # ホスト名に合わせてhome-configを切り替える（例: rurou@MacBook-Air.local）
          USER=$(whoami)

          # shellcheck disable=SC2034
          # HOST=$(scutil --get LocalHostName) # Mac向け
          HOST=$(hostname)
          FLAKE="$(pwd)#$USER@$HOST"

          echo "📦 Switching to flake: $FLAKE"
          home-manager switch --flake "$FLAKE"
        '';
      };
    };
}
