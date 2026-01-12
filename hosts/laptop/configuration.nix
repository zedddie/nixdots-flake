{ pkgs, ... }:

{
  imports = [ ../../base/common-sys.nix /etc/nixos/hardware-configuration.nix ];

  networking.hostName = "laptop";

  programs.steam = { enable = true; };

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
