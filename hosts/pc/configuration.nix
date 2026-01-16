{ config, pkgs, ... }: {
  imports = [ ../../base/common-sys.nix /etc/nixos/hardware-configuration.nix ];

  boot.kernelParams = [ "nvidia-drm.modeset=1" "pcie_aspm=off" ];
  boot.blacklistedKernelModules = [ "nouveau" "nvidiafb" ];

  networking.hostName = "pcnix";
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
    };
  };

  networking.firewall.allowedTCPPorts = [ 22 ];
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # dedicatedServer.openFirewall = true;
  };

  hardware.graphics = { enable = true; };

  services.xserver.videoDrivers = [ "nvidia" ];
  boot.kernelPackages = pkgs.linuxPackages;

  hardware.nvidia = {

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
  virtualisation.docker.enable = true;
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "my-forgejo-runner-01";
      token = "<registration-token>";
      url = "https://code.forgejo.org/";
      # tokenFile = /var/lib/
      labels = [
        "node-22:docker://node:22-bookworm"
        "nixos-latest:docker://nixos/nix"
      ];
      settings = {
        settings = {
          log.level = "info";
          runner = {
            capacity = 1;
            timeout = "3h";
            fetch_interval = "2s";
          };
          container = {
            network = "bridge";
            privileged = false;
            docker_host = "unix:///var/run/docker.sock";
          };
        };
      };
    };
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
  };
  system.stateVersion = "25.11";
}
