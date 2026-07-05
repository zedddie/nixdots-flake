{ config, pkgs, ... }:
{
  imports = [
    ../../base/common-sys.nix
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "nvidia-drm.fbdev=1"
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
    settings.gui.user = "charlotte";
    user = "charlotte";
    group = "users";

    configDir = "/home/charlotte/syncthing/.config/syncthing";

    settings = {
      devices = {
        "vps" = {
          id = "4RDQS6P-PBTTQZM-H65F3AY-4KA3X6X-NZV4MBT-3QK2KEE-M2WLWQO-KBWO2AJ";
        };
      };
      folders = {
        "passwds" = {
          path = "/home/charlotte/secure_vault/";
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
  chaotic.nyx.cache.enable = true;
  chaotic.nyx.overlay.enable = true;
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  services.scx.enable = true;
  services.scx.scheduler = "scx_rusty";

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaPersistenced = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = true;
    gsp.enable = true;
    nvidiaSettings = true;
    package =
      let
        prod = config.boot.kernelPackages.nvidiaPackages.production;
      in
      prod.overrideAttrs (old: {
        passthru = old.passthru // {
          open = old.passthru.open.overrideAttrs (_: {
            allowedReferences = null;
          });
        };
      });
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

  services.xserver.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  services.desktopManager.plasma6.enable = true;

  environment.sessionVariables = {
    EDITOR = "nvim";
    MOZ_DISABLE_RDD_SANDBOX = "1";
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    NVD_BACKEND = "direct";
    PROTON_HIDE_NVIDIA_GPU = "0";
    PROTON_ENABLE_NVAPI = "1";
    DXVK_ASYNC = "1";
    PROTON_USE_NTSYNC = "1";
    PROTON_NO_ESYNC = "1";
    PROTON_NO_FSYNC = "1";
    PROTON_VKD3D_HEAP = "1";
    __GL_SHADER_DISK_CACHE_SIZE = "24000000000";
    MESA_SHADER_CACHE_MAX_SIZE = "24G";
  };

  boot.kernel.sysctl = {
    "vm.max_map_count" = 1048576;
    "vm.swappiness" = 0;
    "vm.vfs_cache_pressure" = 50;
    "vm.dirty_bytes" = 268435456;
    "vm.dirty_background_bytes" = 67108864;
    "vm.dirty_writeback_centisecs" = 1500;
    "vm.page-cluster" = 0;
    "fs.inotify.max_user_instances" = 1024;
    "fs.inotify.max_user_watches" = 524288;
    "fs.file-max" = 2097152;
    "fs.protected_hardlinks" = 1;
    "fs.protected_symlinks" = 1;
    "fs.protected_regular" = 1;
    "fs.protected_fifos" = 1;
    "kernel.kptr_restrict" = 2;
    "kernel.sysrq" = 16;
    "kernel.nmi_watchdog" = 0;
    "kernel.pid_max" = 4194304;
    "kernel.printk" = "3 3 3 3";
    "kernel.core_uses_pid" = 1;
    "net.core.netdev_max_backlog" = 4096;
    "net.ipv4.tcp_keepalive_time" = 120;
    "net.ipv4.conf.default.rp_filter" = 2;
    "net.ipv4.conf.default.accept_source_route" = 0;
    "net.ipv4.conf.default.promote_secondaries" = 1;
  };

  system.stateVersion = "25.11";
}
