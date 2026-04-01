{ config, pkgs, ... }:
{
  imports = [
    ../../base/common-sys.nix
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "pcie_aspm=off"
  ];
  boot.blacklistedKernelModules = [
    "nouveau"
    "nvidiafb"
  ];

  networking.hostName = "pc";
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      PubkeyAuthentication = "yes";
      ChallengeResponseAuthentication = "no";
    };
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui.user = "zedddie";
    user = "zedddie";
    group = "users";

    configDir = "/home/zedddie/syncthing/.config/syncthing";

    settings = {
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
  };
  networking.firewall.allowedTCPPorts = [ 22 ];
  programs.gamemode.enable = true;
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
    # dedicatedServer.openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
  };

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
      url = "https://git.zedddie.rs";
      token = "DfXHaZkx6PyUmfxIBD1GOdF3E8hdwW8vfHWMzVK8";
      labels = [
        "docker:docker://node:22-bookworm"
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
