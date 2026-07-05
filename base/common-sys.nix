{ inputs, pkgs, ... }:

# ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠔⠒⠒⠒⠦⣤⣀⣀⡀⠀⠀
# ⠀⠀⠀⠀⠀⠀⠀⠀⡞⠁⢀⣤⣀⠀⠀⠀⠀⠀⠀⠉⠲⣤⠀
# ⠀⠀⠀⠀⢠⡤⠴⠚⠁⣰⣿⣿⣿⡆⠀⠀⣴⣶⣶⠄⠀⢻
# ⠀⠀⠀⡼⠁⠀⠀⠀⠀⠻⣿⣿⣿⠃⠀⣼⣿⣿⣿⠀⠀⠀⢷⡀
# ⠀⠀⣼⠁⠀⣤⣶⡄⠀⠀⠈⠉⠁⠀⠀⠈⠛⠊⠁⠀⠀⠀⠀⠙⢦
# ⠀⢠⡇⠀⢸⣿⣿⡿⡆⠀⠀⣴⣶⣶⣴⣶⣄⠀⠀⢠⣶⣿⣦⠀⠀⡄
# ⠀⢸⡇⠀⠀⠛⠙⠉⠀⣰⣿⣿⣿⣿⣿⣿⣿⡇⠀⣿⣿⣿⣿⠀⠀⡇
# ⠀⠈⣇⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣿⣿⣷⣿⣷⡀⠀⠉⠉⠀⠀⣸⡟
# ⠀⠀⣿⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⡻⠁
# ⠀⠀⣿⠀⠀⠀⠀⠀⠈⠛⠉⠁⠉⠁⠙⠻⠿⠟⠀⠀⠀⠀⠀⣾⠁
# ⠀⠀⢸⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡟⠁
# ⠀⠀⠀⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⠁

{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";

  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  users.users.charlotte = {
    isNormalUser = true;
    description = "charlotte";
    hashedPassword = "$6$HUkF0/6eFwY12wps$F6jLyqBAWXqJqEh2bxIpyRCrEue.q6/Jv60cU1LQif2rPU5usmF2J0E97sAeWOGTxHyegZ71C/ACm9ZJN2baJ1";
    extraGroups = [
      "networkmanager"
      "wheel"
      "dialout"
      "docker"
      "wireshark"
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  # for zulip to work
  nixpkgs.config.permittedInsecurePackages = [
    "electron-39.8.10"
    "pnpm-10.29.2"
  ];

  programs = {
    fish.enable = true;
    firefox.enable = true;
  };

  system.autoUpgrade.enable = true;
  system.autoUpgrade.dates = "weekly";

  nix.gc.automatic = true;
  nix.gc.dates = "daily";
  nix.gc.options = "--delete-older-than 7d";
  nix.settings.auto-optimise-store = true;

  nix = {
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [ "https://cache.nixos.org/" ];
    };
  };

  security.sudo.extraRules = [
    {
      users = [ "charlotte" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/cp /etc/nixos/configuration.nix /home/charlotte/nixdots/";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.keyd = {
    enable = false;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            escape = "capslock";
            delete = "home";
            home = "delete";
          };
          otherlayer = { };
        };
        extraConfig = ''
          there can be path to config
        '';
      };
    };
  };

  virtualisation.virtualbox.host.enable = false;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

  services.tor.enable = false;
  services.tor.client.enable = false;
  services.i2pd = {
      enable = true;
      proto.http.enable = true;
      proto.socksProxy = {
        enable = true;
        port = 4447;
        address = "127.0.0.1";
      };
      proto.httpProxy = {
        enable = true;
        port = 4444;
        address = "127.0.0.1";
      };
  };
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⡤⠤⣦⢴⠟⠋⠁⠀⢻⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣠⡶⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⣘⣿⣀⠀⠀⠀⠀⠀⠀⢠⣦⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣾⠉⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢉⡀⠀⠀⠀⠀⠀⢴⣾⡙⣻⡷⠂⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣆⠀⠀⠀⠀⠀⠘⢿⡏⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣻⠀⠀⠀⠀⠀⠀⠀⠀⠀⢒⠆⠀⠀⢰⣿⣦⠤⠔⠀⢹⣧⣀⣀⠀⠀⠀⠈⠀⡀⠀⠀⠀
  # ⠀⠀⣸⣆⠀⠀⠀⠀⠀⢸⡏⠀⠀⠀⣀⡀⠀⠀⠀⠀⠾⠂⠀⠀⠀⢻⡏⠀⠀⢾⡛⠻⣯⣉⠁⠀⠀⠀⢀⡿⣤⣀⡀
  # ⠠⣴⣟⣻⡷⢶⠀⠀⠀⣾⠀⠀⠀⢰⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⠀⠈⠓⠠⠀⠈⠛⠛⠛⣿⠛⠂⠀⠐⠻⣷⣼⠟⠉
  # ⠀⠀⠹⡿⠀⠀⠀⠀⠀⣿⣠⣀⣒⠀⢋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⡿⠔⠀⠀⠀⠀⠈⠋⠀⠀
  # ⠀⣠⠀⠀⠀⠀⠀⢀⣤⣿⠟⣿⡉⠀⠘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
  # ⣠⡿⢶⣤⡀⠀⠘⠟⢁⣿⡞⠛⠉⠀⠀⠀⠀⠀⠀⠀⣰⣤⣤⡶⠤⣤⣄⠀⠀⠀⠀⠺⣧⡀⠀⠀⣴⠟⢿⡆⠀⠀⠀
  # ⠛⢷⣾⠋⠀⠀⠀⠀⣾⠛⢷⣤⣀⡀⠀⠀⠀⠀⠀⣼⠋⡁⢻⡀⢀⠀⠉⠀⠀⠀⠀⠀⠈⢻⣤⠀⣿⠐⢸⡇⠀⠀⠀
  # ⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⣷⠄⠀⠀⠀⠁⠀⢀⣸⡷⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⡏⠀⣾⠇⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡏⠀⠀⠀⠀⠀⠀⠀⠘⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠸⣷⣼⡏⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠋⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
  # ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

  environment.systemPackages = with pkgs; [
    keychain
    btop
    bluez
    blueman
    vim
    emacs-nox
    inputs.zix.packages.${pkgs.stdenv.hostPlatform.system}.default
    grc
    git
    exfatprogs
    brightnessctl
  ];
  nixpkgs.config = { };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libunwind
    binutils
    stdenv.cc.cc.lib
    zlib
  ];
  virtualisation.docker = {
    enable = true;
  };
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.comic-shanns-mono
    nerd-fonts.intone-mono
    nerd-fonts.fira-code
    nerd-fonts.departure-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    nerd-fonts.iosevka
    hermit
    dancing-script
    terminus_font
    nerd-fonts.bigblue-terminal
    nerd-fonts.open-dyslexic
    nerd-fonts.fantasque-sans-mono
    nerd-fonts.ubuntu
  ];

  hardware.bluetooth.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.11";

}
