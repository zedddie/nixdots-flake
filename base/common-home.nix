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
    ayugram-desktop
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

    # code utils
    kitty
    gemini-cli-bin
    opencode
    pkg-config
    nixfmt
    markdownlint-cli

    keepassxc
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
      user.email = "zedddie@protonmail.com";
      init.defaultBranch = "master";
    };
    signing = {
      key = "4DF5F89B318FD73C051403AABCA49F4B8DAAE8ED";
      signByDefault = true;
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      AddressFamily inet
      IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
    '';
    matchBlocks = {
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "git";
        identityFile = "~/.ssh/id_codeberg";
        identitiesOnly = true;
      };
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
        identitiesOnly = true;
      };
      "*" = {
        identityFile = "~/.ssh/id_ed25519";
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
    size = 42;
    gtk.enable = true;
    x11.enable = true;
  };

  #git tmux
  programs.home-manager.enable = true;
}
