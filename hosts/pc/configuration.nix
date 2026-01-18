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
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    gsp.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  virtualisation.docker.enable = true;
  services.gitea-actions-runner = {
    package = pkgs.forgejo-runner;
    instances.default = {
      enable = true;
      name = "nixpc-runner";
      url = "http://192.168.1.50:3000/";
      token = "ui8bz627tqCKrjUiHsNwPrm07i9r9Y3VhWi1Ft2P";
      labels = [
        "node-22:docker://node:22-bookworm"
        "nixos-latest:docker://nixos/nix"
      ];
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
