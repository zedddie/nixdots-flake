{
  pkgs,
  zen-browser,
  nixdots-assets,
  ...
}:

#TODO: lookup sops-nix

{
  imports = [ ./packages.nix ];

  home.username = "charlotte";
  home.homeDirectory = "/home/charlotte";

  home.stateVersion = "25.11";
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    gtk4.theme = null;
  };
  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
  programs.fzf.enable = true;
  programs.tmux.enable = true;
  programs.fish = {
    enable = true;
    shellAbbrs = {
      cat = "bat";
      snrs = "sudo nixos-rebuild switch --flake ~/.config/nix/#$hostname --impure";
      h = "head -n 1 ";
      grp = "head -c 42 /dev/urandom | base64 | wl-copy";
      gst = "git status";
      g = "git";
      gp = "git push";
      gf = "git fetch";
      gc = "git commit -m";
      ga = "git add";
      c = "cargo";
    };

    functions = {
      fish_mode_prompt = {
        body = ''
          if test "$fish_key_bindings" = "fish_vi_key_bindings"
            switch $fish_bind_mode
              case default
                  set_color --bold --background red red
                  echo '[N]'
              case insert
                  set_color f7daea --bold --background normal
                  echo '[I]'
              case visual
                  set_color --bold --background magenta white
                  echo '[V]'
            end
            set_color normal
            echo -n ' '
        end
      '';
      };

      fish_prompt = {
        body =
        ''
          function fish_prompt -d "Write out the prompt"
          printf '%s@%s %s%s%s > ' $USER $hostname \
              (set_color e791bf) (prompt_pwd) (set_color e791bf)
          end
        '';
      };
    };
    interactiveShellInit = 
    ''
      set -g fish_greeting ""
      fish_vi_key_bindings
      set -g fish_cursor_default block
      if status is-login
        keychain --quiet --eval $HOME/.ssh/id_ed25519 | source
      end
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
      user.name = "charlotte";
      user.email = "zedddie@protonmail.com";
      init.defaultBranch = "main";
    };
  };
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    extraConfig = ''
      AddressFamily inet
      #IdentityAgent /run/user/1000/gnupg/S.gpg-agent.ssh
      AddKeysToAgent yes
    '';
    settings = {
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

  services.ssh-agent.enable = true;

  programs.kitty = {
    enable = true;
    font = {
      name = "ComicShannsMonoNFM-Regular";
      size = 22;
    };
    shellIntegration = {
      enableBashIntegration = false;
      enableZshIntegration = false;
      mode = "no-cursor";
    };
    themeFile = "GruvboxMaterialDarkHard";
    settings = {
      cursor_shape = "block";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";

      window_padding_width = 10;
      window_border_width = 2;
      hide_window_decorations = "no";
      background_opacity = "1";

      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{index}: {title}";

      scrollback_lines = 10000;
      scrollback_pager = "less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER";
    };

    keybindings = {
      "ctrl+shift+u" = "launch --stdin-source=@screen_scrollback --type=overlay vim -";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      "ctrl+shift+equal" = "change_font_size all +1.0";
      "ctrl+shift+minus" = "change_font_size all -1.0";
      "ctrl+shift+backspace" = "change_font_size all 0";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = false;
    pinentry.package = pkgs.pinentry-tty;
    defaultCacheTtl = 3600;
  };
  home.sessionVariables = {
    PATH = "$HOME/.cargo/bin:$PATH";
  };

  programs.home-manager.enable = true;
}
