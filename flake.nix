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
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };

      overlays = [
        inputs.neovim-nightly-overlay.overlays.default
      ];
      username = "rurou";
      hostname = "MacBook-Air.local";
    in {
      # homeConfigurations."${username}@${hostname}" = inputs.home-manager.lib.homeManagerConfiguration {
      # ホスト名はいまの運用だと冗長なので削除
      homeConfigurations."${username}" = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [
          ./home/mac.nix
          neovim-flake.homeManagerModules.default
          {
            nixpkgs.overlays = overlays;
          }
          nixvim.homeModules.nixvim
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
        program = "${self.packages.${system}.update-home}/bin/update-home";
          meta = {
            description = "Run home-manager switch using flake";
            license = pkgs.lib.licenses.mit;
            maintainers = [ "rurou" ];
          };
      };

      packages.${system}.update-home = import ./update_home-manager.nix {
        inherit pkgs system self;
      };
    };
}
