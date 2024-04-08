{ config, lib, pkgs, ... }@args:
let
  hlib = import ../lib { inherit lib pkgs; };
in
{

  imports = [ "${args.impermanence}/home-manager.nix" ];

  home.username = "hil";
  home.homeDirectory = "/home/hil";

  home.packages = with pkgs;[
    htop
    prismlauncher
    kitty
    firefox
    fastfetch
    yazi
    nix-output-monitor
    v2raya
    qq
    yesplaymusic
    hypridle
    hyprlock
    hyprpaper
    lxqt.lxqt-policykit
    grim
    slurp
    dconf
    mako
    bottles
    (hlib.wrapElectron { pkgName = "vscode"; binName = "code"; })
    wev
    obs-studio
    vlc
  ];

  home.persistence."/persistent/home/hil" = {
    directories = [
      "Downloads"
      "Music"
      "Pictures"
      "Documents"
      "Videos"
      "Desktop"
      ".local/share"
      ".pki"
      ".mozilla"
      ".vscode"
      ".config/Code/User"
      ".config/QQ"
    ];
    allowOther = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = false;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 21;
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.flat-remix-gtk;
      name = "Flat-Remix-GTK-Blue";
    };

    iconTheme = {
      package = pkgs.fluent-icon-theme;
      name = "Fluent";
    };

    font = {
      name = "Sans";
      size = 11;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qtct";
  };

  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-rime
      fcitx5-configtool
      fcitx5-chinese-addons
      fcitx5-gtk
      fcitx5-material-color
    ];
  };

  programs.git = {
    enable = true;
    userName = "hhhil";
    userEmail = "git@hhhil.com";
  };

  programs.bash = {
    enable = true;
  };

  programs.bash.initExtra = ''
    if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ''${BASH_EXECUTION_STRING} ]]
    then
      shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
      exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
    fi
  '';

  programs.fish.enable = true;

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  xdg.configFile."starship.toml" = {
    source = ./starship/nerd-font-symbols.toml;
  };

  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      source = [
        "./land/env.conf"
        "./land/monitor.conf"
        "./land/setting.conf"
        "./land/program.conf"
        "./land/rule.conf"
        "./land/bind.conf"
        "./land/exec.conf"
        # "./land/expo.conf"

      ];
    };
    # plugins = [
    #   args.hyprland-plugins.packages.${pkgs.system}.hyprexpo
    # ];

  };
  wayland.windowManager.hyprland.systemd.variables = [ "--all" ];

  xdg.configFile."hypr/land" = {
    source = ./hyprland;
    recursive = true;
  };

  xdg.configFile."hypr/hypridle.conf" = {
    source = ./hypridle/hypridle.conf;
  };

  xdg.configFile."hypr/hyprlock.conf" = {
    source = ./hyprlock/hyprlock.conf;
  };

  xdg.configFile."hypr/hyprpaper.conf" = {
    source = ./hyprpaper/hyprpaper.conf;
  };

  programs.wofi = {
    enable = true;
  };

  programs.waybar = {
    enable = true;
  };

  xdg.configFile."waybar" = {
    source = ./waybar;
    recursive = true;
  };

  xdg.configFile."wofi" = {
    source = ./wofi;
    recursive = true;
  };

  xdg.configFile."fcitx5" = {
    source = ./fcitx5;
    recursive = true;
  };

  xdg.configFile."mako" = {
    source = ./mako;
    recursive = true;
  };

  services.mako.enable = true;

  programs.kitty = {
    enable = true;
    font.name = "monospace";
  };

  # programs.vscode = {
  #   enable = true;
  # };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

}
