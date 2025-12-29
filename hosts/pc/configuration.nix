{ config, pkgs, ... }:

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
  imports = [ ./hardware-configuration.nix ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "pcie_aspm=off"
  ];
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidiafb"
  ];

  networking.hostName = "pcnix";

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

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            capslock = "esc";
            escape = "capslock";
          };
          otherlayer = { };
        };
        extraConfig = ''
          there can be path to config
        '';
      };
    };
  };
  services.i2pd = {
    enable = false;
    proto.http.enable = true;
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

  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelPackages = pkgs.linuxPackages;

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;
    nvidiaPersistenced = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    open = true;
    gsp.enable = true;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  # services.xserver.enable = true;
  # services.xserver.displayManager.startx.enable = true;
  # services.xserver.windowManager.dwm = {
  #   enable = true;
  #   package = pkgs.dwm.overrideAttrs {
  #     src = ./dwm;
  #   };
  # };
  programs.hyprland.enable = true;
  environment.systemPackages = with pkgs; [
    # dmenu
    # st

    keychain
    btop
    bluez
    blueman
    neovim
    grc

    git
    exfatprogs
    brightnessctl
  ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    libunwind
    binutils
  ];
  virtualisation.docker = {
    enable = true;
  };
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    dedicatedServer.openFirewall = true;
  };
  fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.departure-mono
    nerd-fonts.droid-sans-mono
    nerd-fonts.noto
    nerd-fonts.hack
    dancing-script
    terminus_font
    nerd-fonts.bigblue-terminal
    nerd-fonts.open-dyslexic
    nerd-fonts.ubuntu
  ];

  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
  # environment.sessionVariables.EDITOR = "nvim";

  environment.sessionVariables = {
    XCURSOR_THEME = "hackneyed";
    XCURSOR_SIZE = "24";
    GTK_CURSOR_THEME = "hackneyed";
    GTK_CURSOR_SIZE = "24";

    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };

  hardware.bluetooth.enable = true;
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
    };
  };

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?

}
