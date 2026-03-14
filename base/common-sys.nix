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

  users.users.zedddie = {
    isNormalUser = true;
    description = "zedddie";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "wireshark"
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

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
      users = [ "zedddie" ];
      commands = [
        {
          command = "/run/current-system/sw/bin/cp /etc/nixos/configuration.nix /home/zedddie/nixdots/";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui.user = "zedddie";
    user = "zedddie";
    group = "users";

    configDir = "/home/zedddie/syncthing/.config/syncthing";

    devices = {
      "vps" = {
        id = "4RDQS6P-PBTTQZM-H65F3AY-4KA3X6X-NZV4MBT-3QK2KEE-M2WLWQO-KBWO2AJ";
      };
    };
    folders = {
      "passwds" = {
        path = "/home/zedddie/secure_vault/";
        devices = [ "vps" ];
      };
    };
  };

  services.keyd = {
    enable = true;
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
  services.tor.enable = true;
  services.tor.client.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "user-with-access-to-virtualbox" ];

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

  programs.hyprland.enable = true;
  # services.displayManager.ly.enable = true;
  # services.xserver = {
  #   enable = true;
  #   windowManager.dwm = {
  #     enable = true;
  #     package = pkgs.dwm.overrideAttrs rec {
  #       pname = "dwm";
  #       version = "6.8";
  #       src = pkgs.fetchurl {
  #         url = "https://dl.suckless.org/dwm/${pname}-${version}.tar.gz";
  #         hash = "sha256-vPVAWJrRdNQHP076ZYgoQR4vW6Yxls+va3E2NwD1kLc=";
  #       };
  #       # patches = [
  #       #   (pkgs.fetchpatch {
  #       #     url = "https://dwm.suckless.org/patches/alt-tab/dwm-alttab-6.4.diff";
  #       #     hash = "sha256-MiIFczEsIsK+lc07vZOeJHXphC9BdkEHgXJHQ/yPB/U=";
  #       #   })
  #       #   (pkgs.fetchpatch {
  #       #     url = "https://dwm.suckless.org/patches/autoresize/dwm-autoresize-6.1.diff";
  #       #     hash = "sha256-RIYw0Is9/H5yhWbH/HiOQdhDIs/IJAaGQIvP36QcUJM=";
  #       #   })
  #       # ];
  #     };
  #   };
  # };
  environment.systemPackages = with pkgs; [
    #ts is required here as there is no otherr way to declare
    #its plugins to be reproducible(afaik)
    pidgin-with-plugins

    keychain
    btop
    bluez
    blueman
    vim
    emacs-nox
    # neovim
    inputs.zix.packages.${pkgs.stdenv.hostPlatform.system}.default
    grc

    torsocks
    git
    exfatprogs
    brightnessctl
  ];
  nixpkgs.config = {
    packageOverrides =
      pkgs: with pkgs; {
        pidgin-with-plugins = pkgs.pidgin.override { plugins = [ pidginPackages.pidgin-otr ]; };
      };
  };
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libunwind
    binutils
  ];
  virtualisation.docker = {
    enable = true;
  };
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  system.stateVersion = "25.11";

}
