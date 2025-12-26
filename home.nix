{ config, pkgs, zen-browser, ... }:

{
  home.username = "zedddie";
  home.homeDirectory = "/home/zedddie";

  # backward compatibity version(guide says dont chanfge, in case
  # future me will fporget)
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
	vesktop
	telegram-desktop
	obsidian
	zen-browser.packages.${pkgs.system}.default
  ]
  programs.home-manager.enable = true;
}
