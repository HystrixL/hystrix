{ config, lib, pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";
  boot.tmp.cleanOnBoot = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "hixs";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.xserver.videoDrivers = [ "nvidia" ];

  environment.persistence."/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/etc/ssh"
      "/etc/v2raya"
    ];
    files = [
      "/etc/machine-id"
    ];
  };

  nix.settings = {
    trusted-users = [ "hil" ];

    substituters = [
      "https://nix-community.cachix.org"
      "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
      "https://cache.nixos.org"
    ];

    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };


  services.printing.enable = true;
  services.blueman.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    configPackages = [ pkgs.xdg-desktop-portal-hyprland ];
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.mutableUsers = false;
  users.users.root.hashedPassword = builtins.readFile ../secret/userpwd/root;
  users.users.hil = {
    hashedPassword = builtins.readFile ../secret/userpwd/hil;
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    curl
    tree
    fastfetch
    ncdu
    pciutils
    nvtopPackages.full
    lshw
    glxinfo
    brightnessctl
    cliphist
    wl-clipboard
    playerctl
    python3
    jre
    nixpkgs-fmt
    unzip
    nix-index
  ];


  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      maple-mono-SC-NF
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
        monospace = [ "Maple Mono SC NF" ];
        emoji = [ "Noto Color Emoji" ];
      };
      hinting = {
        enable = true;
        autohint = false;
        style = "slight";
      };
      antialias = true;
      subpixel = {
        lcdfilter = "default";
        rgba = "rgb";
      };
    };
  };

  systemd.tmpfiles.rules = [
    "L /var/lib/dri/amd - - - - /dev/dri/by-path/pci-0000:06:00.0-card"
    "L /var/lib/dri/nvidia - - - - /dev/dri/by-path/pci-0000:01:00.0-card"
  ];
  security.polkit.enable = true;

  programs.fuse.userAllowOther = true;
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
  services.openssh.enable = true;
  services.v2raya.enable = true;
  services.power-profiles-daemon.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  system.copySystemConfiguration = false;

  system.stateVersion = "24.05";
}
