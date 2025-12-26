{
  config,
  pkgs,
  zen-browser,
  ...
}:

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
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Classic";
    size = 16;
  };

  programs.home-manager.enable = true;
}
