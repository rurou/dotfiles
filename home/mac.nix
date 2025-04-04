{
  config,
  pkgs,
  lib,
  # neovim-flake,
  ...
}:


let
  cliTools = with pkgs; [
    bandwhich
    bat
    binwalk
    bottom
    coreutils
    curl
    ddrescue
    difftastic
    exiftool
    fd
    ffmpegthumbnailer
    fish
    foremost
    fzf
    ghq
    gitui
    gnutar
    jq
    lsd
    darwin.lsusb
    mas
    neofetch
    poppler
    ripgrep
    tmux
    topgrade
    tree
    unar
    yazi
    git-credential-oauth
    xdg-ninja
    nodejs
    # nvfetcher
    #tree-sitter
    dust
    glances
    gdu
    dua
  ];
  
  guiTools = with pkgs; [
    # wezterm
    zed-editor
  ];

  fzfFishNoTest = pkgs.fishPlugins.fzf-fish.overrideAttrs (_: {
    doCheck = false;
  });
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rurou";
  home.homeDirectory = "/Users/rurou";

  nix = {
    package = pkgs.nixVersions.stable;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      extra-trusted-users = [ "rurou" ];
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.


  home.packages = cliTools ++ guiTools;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  # home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

  # ];

  programs.fish = {
    enable = true;

    plugins = with pkgs.fishPlugins; [
      {
        name = "bass";
        src = bass;
      }
      {
        name = "fzf-fish";
        src = fzfFishNoTest;
      }
      {
        name = "z";
        src = z;
      }
    ];

    interactiveShellInit = ''
      if not functions -q fisher
        echo "Installing fisher..."
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher
      end
    '';

    shellAliases = {
      ls = "lsd -F --color=auto";
      ll = "lsd -lahF --color=auto";
    };
  };
  programs.git = {
    enable = true;

    userName = "rurou";
    userEmail = "28745212+rurou@users.noreply.github.com";
  };
  programs.git-credential-oauth.enable = true;

  # programs.nixvim = {
  #   enable = true;
  #   # plugnins = [
  #   #   nvim-treesitter
  #   # ];
  #   package = pkgs.neovim;
  #   # package = pkgs.overlays.neovim-nightly;
  # };

  programs.neovim = {
    enable = true;

    # plugins = [
    #   nvim-treesitter
    # ];
  };

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
    ".config/fish/fish_plugins".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/fish/fish_plugins";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";
    ".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/wezterm";
    ".config/alacritty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/alacritty";
    ".config/bat".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/bat";
    ".config/lsd".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/lsd";
    ".config/karabiner/karabiner.json".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/karabiner/karabiner.json";
    ".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/tmux";
    ".config/zsh".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/zsh";
    ".config/vim".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/vim";
    ".config/topgrade.toml".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/topgrade.toml";
  };

  # xdg.configFileで配置するとホットリロード出来ない、--impureオプションが必要になるなど
  # 問題が多いので、home.fileに戻す
  # xdg.configFile = {
  #   "fish/fish_plugins".source = "${config.home.homeDirectory}/dotfiles/fish/fish_plugins";
  #   "nvim".source = "${config.home.homeDirectory}/dotfiles/nvim";
  #   "wezterm".source = "${config.home.homeDirectory}/dotfiles/wezterm";
  # };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rurou/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "vim";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/.local/bin"
    "$HOME/.nix-profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
  ];

  home.activation =
    with lib.hm;
    with lib.meta;
    with config.home;
    {
      # installFisher = dag.entryAfter ["writeBoundary"] ''
      #   run ${getExe pkgs.fish} -c "${getExe pkgs.curl} -sL https://git.io/fisher | source && fisher update"
      # '';
      # installAstroNvim = lib.hm.dag.entryAfter ["writeBoundary"] ''
      #   run "${lib.meta.getExe pkgs.git} clone --depth 1 https://github.com/AstroNvim/template ${config.home.homeDirectory}/.config/nvim"
      #   run "rm -rf ~/.config/nvim/.git"
      # '';
    };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
