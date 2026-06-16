{ pkgs, ... }:

{
  imports = [
    ../../base/common-sys.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "laptop";

  programs.steam = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui.user = "charlotte";
    user = "charlotte";
    group = "users";

    configDir = "/home/charlotte/syncthing/.config/syncthing";

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

  environment.systemPackages = with pkgs; [ brightnessctl ];
  programs.wireshark = {
    enable = true;
    dumpcap.enable = true;
    package = pkgs.wireshark;
  };
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.EDITOR = "nvim";
  system.stateVersion = "25.11";
}
