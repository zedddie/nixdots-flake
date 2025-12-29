{ pkgs, ... }:

{
  imports = [
    ../../base/common-sys.nix
    /etc/nixos/hardware-configuration.nix
  ];

  networking.hostName = "nixos";

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
  environment.sessionVariables.EDITOR = "nvim";
  system.stateVersion = "25.11";
}
