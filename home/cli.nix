{
  config,
  pkgs,
  ...
}: {
  programs = {
    btop = {
      enable = true;
      settings = {
        theme_background = false;
        vim_keys = true;
        rounded_corners = false;
      };
    };

    home-manager.enable = true;

    less = {
      enable = true;
      keys = ''
        h left-scroll
        l right-scroll
      '';
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      # enableFishIntegration = true;
      silent = true;
      nix-direnv.enable = true;
    };

    gh.enable = true;

    lazygit.enable = true;

    gitui.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      options = ["--cmd cd"];
    };

    bat.enable = true;

    eza = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      git = true;
      icons = true;
      extraOptions = ["--hyperlink"];
    };

    sptlrx = {
      enable = true;
      settings = {
        player = "mpd";
        mpd.address = "127.0.0.1:6600";
        # player = "mpris";
        # host = "lyricsapi.vercel.app";
        # ignoreErrors = true;
        # timerInterval = 200;
        # updateInterval = 2000;
        # style = with config.lib.stylix.colors.withHashtag; {
        #   hAlignment = "center";
        #   before = {
        #     foreground = base03;
        #     bold = false;
        #     faint = true;
        #   };
        #   current = {
        #     foreground = base0B;
        #     bold = true;
        #     italic = true;
        #   };
        #   after.foreground = base03;
        # };
        # mpris.players = ["spotify_player" "mpv"];
      };
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = false;
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      shellWrapperName = "ya";
      keymap = {
        manager.prepend_keymap = [
          {
            run = ''shell 'for path in "$@"; do echo "file://$path"; done | wl-copy -t text/uri-list' --confirm'';
            on = ["y"];
          }
          {
            run = ''shell "$SHELL" --block --confirm'';
            on = ["w"];
          }
          {
            run = "plugin --sync max-preview";
            on = ["T"];
          }
          {
            run = "tasks_show";
            on = ["W"];
          }
        ];
        tasks.prepend_keymap = [
          {
            run = "close";
            on = ["W"];
          }
        ];
      };
      plugins = {
        max-preview = "${pkgs.yazi-plugins}/share/max-preview.yazi";
      };
      settings = {
        manager = {
          ratio = [1 3 3];
          sort_by = "natural";
          show_hidden = true;
        };
      };
    };
  };
}
