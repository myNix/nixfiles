# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  # nixos-hardware = (import ./nix-misc/external-sources.nix).nixos-hardware;
  i3_tray_output = "eDP1";
  mvaude_config = import ./config { inherit i3_tray_output pkgs; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./home.nix
      ./vpn
      "${builtins.fetchTarball https://github.com/rycee/home-manager/archive/master.tar.gz}/nixos"
      # "${nixos-hardware}/lenovo/thinkpad/t480s"
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  fonts.enableFontDir = true;
  fonts.enableGhostscriptFonts = true;
  fonts.fonts = with pkgs; [
    anonymousPro
    dejavu_fonts
    freefont_ttf
    liberation_ttf
    source-code-pro
    terminus_font
    nerdfonts
  ];

  networking.hostName = "thaddius"; # Define your hostname.
  networking.hostId = "cfe21c37";
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # networking.networkmanager.enable = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  nixpkgs.config.allowUnfree = true;

  environment.etc = pkgs.mvaude_config.environment_etc;

  environment.shellAliases = {
    "vi" =  "nvim";
    "vim" = "nvim";
  };

  environment.systemPackages = with pkgs;
  mvaude_config.system_packages ++
  [
    # mvaude_config.update_xkbmap
    mvaude_config.theme_switch

    termite.terminfo

    xsel # needed for neovim to support copy/paste

    wget
    gitAndTools.gitflow
    gitAndTools.tig
    gitFull
    gnumake
    htop
    neovim
    ngrok
    scrot
    slack
    thunderbird
    pass
    asciinema
    mpv
    youtube-dl
    pavucontrol
    firefox
    gnupg
    unrar
    unzip
    which
    tree
    zathura

    docker_compose
   

    gnome3.dconf
    gnome3.defaultIconTheme
    gnome3.gnome_themes_standard
  ];
  nixpkgs.config.packageOverrides = pkgs: (import ./pkgs { inherit pkgs mvaude_config; });

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  programs.ssh.startAgent = true;
  programs.zsh.enable = true;
  programs.zsh.enableCompletion = true;
  programs.zsh.syntaxHighlighting.enable = true;
  programs.zsh.syntaxHighlighting.highlighters = [ "main" "brackets" "cursor" "root" "line" ];
  programs.zsh.enableAutosuggestions = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.xkbModel = "thinkpad60";
  # services.xserver.autoRepeatDelay = 200;
  # services.xserver.autoRepeatInterval = 50;

  services.xserver.windowManager.default = "i3";
  services.xserver.windowManager.i3.enable = true;
  services.xserver.windowManager.i3.configFile = "/tmp/config/i3";
  services.xserver.displayManager.slim.defaultUser = "maxter";
  services.xserver.desktopManager.default = "none";
  services.xserver.desktopManager.xterm.enable = false;
  services.xserver.exportConfiguration = true;

  services.xserver.videoDrivers = [ "intel" ];
  services.xserver.deviceSection = ''
    Option "Backlight" "intel_backlight"
    BusID "PCI:0:2:0"
  '';
  services.xserver.enableTCP = false;
  services.xserver.updateDbusEnvironment = true;

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.mvaude_config.theme_switch}/bin/switch-theme
  '';

  services.dbus.enable = true;

  # services.xserver.autorun = true;
  # Enable the KDE Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;

  users.defaultUserShell = pkgs.zsh;
  # users.mutableUsers = false;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers."maxter" = {
    isNormalUser = true;
    home = "/home/maxter";
    group = "users";
    extraGroups = ["wheel" "docker" "vboxusers"];
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
  };

  # enable docker
  virtualisation.docker.enable = true;
  # virtualisation.docker.storageDriver = "btrfs";
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  nixpkgs.config.virtualbox.enableExtensionPack = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "18.03"; # Did you read the comment?

}
