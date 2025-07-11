{
  config,
  pkgs,
  lib,
  # neovim-flake,
  ...
}:


let
  # with pkgs; はすべてを検索してしまい、evaluation warning が大量に出るのでやめる
  cliTools = [
    pkgs.bandwhich
    pkgs.bat
    pkgs.binwalk
    pkgs.bottom
    pkgs.coreutils
    pkgs.curl
    pkgs.ddrescue
    pkgs.difftastic
    pkgs.exiftool
    pkgs.fd
    pkgs.ffmpegthumbnailer
    pkgs.fish
    pkgs.foremost
    pkgs.fzf
    pkgs.ghq
    pkgs.gitui
    pkgs.gnutar
    pkgs.jq
    pkgs.lsd
    pkgs.darwin.lsusb
    pkgs.mas
    pkgs.neofetch
    pkgs.poppler
    pkgs.ripgrep
    pkgs.tmux
    pkgs.topgrade
    pkgs.tree
    pkgs.unar
    pkgs.yazi
    pkgs.git-credential-oauth
    pkgs.xdg-ninja
    pkgs.nodejs
    # nvfetcher
    #tree-sitter
    pkgs.dust
    pkgs.glances
    pkgs.gdu
    pkgs.dua
    pkgs.byobu
    # bitwarden-cliは20250607時点でNixだとbrokenだったので、Homebrewで入れる
    # pkgs.bitwarden-cli
    pkgs.uv
    pkgs.jankyborders
  ];
  
  guiTools = [
    # pkgs.wezterm
    # ghosttyは20250603時点でNixだとbrokenだったので、Homebrewで入れる
    # pkgs.ghostty
    pkgs.zed-editor
    # https://github.com/lmstudio-ai/lmstudio-bug-tracker/issues/347
    # /Applications以外からの起動が出来ないissueのために
    # 明示的にbrokenになっているのでHomebrewに移動
    # pkgs.lmstudio
    pkgs.sketchybar
    pkgs.alt-tab-macos
    pkgs.aerospace
  ];

  fonts = [
    pkgs.udev-gothic-nf
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
  home.stateVersion = "25.05"; # Please read the comment before changing.


  home.packages = cliTools ++ guiTools ++ fonts;
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

  launchd.agents.sketchybar = {
    enable = true;
    config = {
      Label = "dev.rurou.sketchybar";
      ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];
      RunAtLoad = true;
      KeepAlive = true;
      EnvironmentVariables = {
        PATH = "${pkgs.sketchybar}/bin:${config.home.homeDirectory}/.nix-profile/bin:/run/current-system/sw/bin:/usr/bin:/bin";
        CONFIG_DIR = "${config.home.homeDirectory}/.config/sketchybar";
      };
      StandardErrorPath = "${config.xdg.dataHome}/sketchybar/sketchybar.err.log";
      StandardOutPath = "${config.xdg.dataHome}/sketchybar/sketchybar.out.log";
    };
  };

  launchd.agents.jankyborders = {
    enable = true;
    config = {
    Label = "dev.rurou.jankyborders";
    ProgramArguments = [ "${pkgs.jankyborders}/bin/borders" ];
    RunAtLoad = true;
    KeepAlive = true;
    EnvironmentVariables = {
      PATH = "${pkgs.jankyborders}/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin:/usr/bin:/bin";
    };
    StandardOutPath = "${config.xdg.dataHome}/jankyborders/jankyborders.out.log";
    StandardErrorPath = "${config.xdg.dataHome}/jankyborders/jankyborders.err.log";
    };
  };

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
        cd $HOME/dotfiles/fish

        mv fish_plugins fish_plugins.bak
        curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher

        rm fish_plugins
        mv fish_plugins.bak fish_plugins
      end
    '';

    shellAliases = {
      ls = "lsd -F --color=auto";
      ll = "lsd -lahF --color=auto";
    };

    generateCompletions = true;
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
    # dotDir = ".config/zsh";
  };

  fonts.fontconfig.enable = true;

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
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/ghostty";
    ".config/sketchybar".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/sketchybar";
    ".config/aerospace".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/aerospace";
    ".config/borders".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/borders";
  };

  # xdg.configFileで配置するとホットリロード出来ない、--impureオプションが必要になるなど
  # 問題が多いので、home.fileに戻す
  xdg.configFile = {
  #   "fish/fish_plugins".source = "${config.home.homeDirectory}/dotfiles/fish/fish_plugins";
  #   "nvim".source = "${config.home.homeDirectory}/dotfiles/nvim";
  #   "wezterm".source = "${config.home.homeDirectory}/dotfiles/wezterm";
    # "zsh/.zshrc".source = ../zsh/.zshrc;
    # "zsh/.zprofile".source = ../zsh/.zprofile;
  };

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
    ZDOTDIR = "${config.xdg.configHome}/zsh";
  };

  home.sessionPath = [
    "/opt/homebrew/bin"
    "$HOME/.local/bin"
    "$HOME/.nix-profile/bin"
    "/etc/profiles/per-user/${config.home.username}/bin"
  ];

  home.extraActivationPath = [
    pkgs.fish
  ];

  home.activation =
    with lib.hm;
    with lib.meta;
    with config.home;
    {
      # fishUpdateCompletions = dag.entryAfter [ "installPackages" ] ''
      #   FISH_BIN=$(command -v fish)
      #   if [ -n "$FISH_BIN" ]; then
      #     echo "Found fish at: $FISH_BIN" >&2
      #     $FISH_BIN -c 'fish_update_completions'
      #   else
      #     echo "fish not found in PATH." >&2
      #   fi
      # '';
    };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
