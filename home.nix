{
  pkgs,
  zen-browser,
  nixdots-assets,
  ...
}:

let
  installCursor =
    name:
    pkgs.stdenv.mkDerivation {
      pname = "cursor-${name}";
      version = "1.0";
      src = "${nixdots-assets}/cursors/${name}";
      installPhase = ''
        mkdir -p $out/share/icons/${name}
        cp -r . $out/share/icons/${name}
      '';
    };
in
{
  home.username = "zedddie";
  home.homeDirectory = "/home/zedddie";

  # backward compatibity version(guide says dont chanfge, in case
  # future me will fporget)
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    gnupg
    # communication
    vesktop
    telegram-desktop
    gajim

    # learn
    obsidian

    # utils
    unzip
    pavucontrol
    dunst
    slurp
    grim
    wl-clipboard

    # 4hypr
    waybar
    rofi
    swww

    #
    spotify

    # gaming related
    obs-studio
    mangohud
    protonup-qt
    lutris
    bottles
    heroic

    # code utils
    kitty
    gemini-cli-bin
    opencode
    pkg-config
    nixfmt
    markdownlint-cli

    fastfetch
    # custom
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    (installCursor "Charlotte-Suzu")
    (installCursor "Hatsune-Miku")
  ];
  programs.fzf.enable = true;
  programs.tmux.enable = true;
  programs.fish = {
    enable = true;
    shellAbbrs = {
      snrs = "sudo nixos-rebuild switch";
      senx = "sudoedit /etc/nixos/configuration.nix";
      gst = "git status";
      g = "git";
      gp = "git push";
      gf = "git fetch";
      gc = "git commit -m";
      ga = "git add";
      c = "cargo";
    };
    interactiveShellInit = ''
      set -g fish_greeting ""
      fish_vi_key_bindings
      set -gx SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
      gpg-connect-agent updatestartuptty /bye > /dev/null
    '';
    plugins = [
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "z";
        src = pkgs.fishPlugins.z.src;
      }
    ];
  };
  programs.git = {
    enable = true;
    settings = {
      user.name = "zedddie";
      user.email = "zedddiezxc@gmail.com";
      init.defaultBranch = "master";
    };

    # signing = {}; gpg later
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
    '';
    matchBlocks = {
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = "~/.ssh/id_codeberg";
        extraOptions = {
          "AddKeysToAgent" = "yes";
        };
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          "AddKeysToAgent" = "yes";
        };
        identitiesOnly = true;
      };
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
        extraOptions = {
          "AddKeysToAgent" = "yes";
        };
      };
    };
  };
  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 3600;
  };
  home.pointerCursor = {
    package = installCursor "Hatsune-Miku";
    name = "Hatsune-Miku";
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  #git tmux
  programs.home-manager.enable = true;
}
