{ config, pkgs, ... }:

{
  imports = [ <home-manager/nix-darwin> ];
  nixpkgs.overlays = [
    #    (import ./overlays/yabai.nix)
  ];

  home-manager.useUserPackages = true;
  homebrew = {
    enable = true;
    autoUpdate = false;
    casks = [ ];
    brews = [ "zellij" "koekeishiya/formulae/skhd" ];
  };

  users.users.gila.home = "/Users/gila";
  home-manager.users.gila = { pkgs, config, ... }: {

    manual.manpages.enable = true;
    #    nixpkgs.overlays = [
    #      (import (builtins.fetchTarball {
    #        url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
    #      }))
    #      (import "${fetchTarball "https://github.com/nix-community/fenix/archive/main.tar.gz"}/overlay.nix")
    #    ];

    home.stateVersion = "22.05";
    home.packages = with pkgs;
      [
        kubernetes-helm
        ansible-lint
        fd
        k9s
        kubectl
        mosh
        nixpkgs-fmt
        nixfmt
        ripgrep
        terraform-ls
        terraform.full
        tfk8s
        wget
      ];

    programs.starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = "$hostname$username$directory$git_branch$nix_shell";
      };
    };

    programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        bufferline-nvim
        cmp-buffer
        cmp-calc
        cmp-cmdline
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-path
        cmp-zsh
        lazy-nvim
        lsp-zero-nvim
        lspkind-nvim
        null-ls-nvim
        nvim-cmp
        nvim-lspconfig
        nvim-tree-lua
        nvim-treesitter.withAllGrammars
        nvim-colorizer-lua
        onedark-nvim
        packer-nvim
        plenary-nvim
        telescope-nvim
        vim-vsnip
        whitespace-nvim
        rust-tools-nvim
      ];

      extraPackages = with pkgs; [
        ansible-language-server
        black
        gopls
        lua-language-server
        luaformatter
        nixpkgs-fmt
        pyright
        rnix-lsp
        stylua
        yamlfix
      ];

      extraConfig = ''
        :luafile ~/.config/nvim/lua/init.lua
      '';
    };

    programs.dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.direnv = {
      enable = true;
      enableZshIntegration = true;
    };

    programs.fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultOptions =
        [ "--height 40%" "--layout=reverse" "--border" "--inline-info" ];
    };

    programs.ssh =
      {
        enable = true;
        extraConfig = ''
        '';
      };

    programs.zsh = {
      initExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
        source ~/.cargo/env
        export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
        # start gpg-agent, if it isn't started already
        gpgconf --launch gpg-agent
        gpg-connect-agent /bye
        export GPG_TTY=$(tty)
        LANG="en_IE.UTF-8"
      '';
      enable = true;
      sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      enableAutosuggestions = true;
      enableCompletion = true;
      history = {
        expireDuplicatesFirst = true;
        extended = true;
        save = 50000;
        share = true;
      };

      plugins = [
        {
          name = "fast-syntax-highlighting";
          file = "fast-syntax-highlighting.plugin.zsh";
          src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = "${pkgs.zsh-nix-shell}/share/zsh-nix-shell";
        }
      ];
      defaultKeymap = "viins";

      oh-my-zsh = {
        enable = true;
        plugins = [
          "colored-man-pages"
          "command-not-found"
          "kubectl"
          "docker"
          "extract"
          "fzf"
          "git"
          "man"
          "vi-mode"
        ];
      };
    };

    programs.tmux = {
      clock24 = true;
      enable = true;
      keyMode = "vi";
      sensibleOnTop = true;
      shortcut = "a";
      historyLimit = 5000000;
      extraConfig = ''
        #set -g default-terminal "alacritty"
        set -g mouse on
        set -s focus-events on
        set -sg escape-time 0
        set -sg repeat-time 600
        set -as terminal-overrides ',*:Tc'
        set-window-option -g automatic-rename on
        set-option -g set-titles on
        setw -q -g utf8 on

        bind -r ^ last-window
        bind -r k select-pane -U
        bind -r j select-pane -D
        bind -r h select-pane -L
        bind -r l select-pane -R

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l

        unbind-key -T copy-mode-vi v

        bind-key -T copy-mode-vi v \
          send-keys -X begin-selection

        bind-key -T copy-mode-vi 'C-v' \
          send-keys -X rectangle-toggle

        bind-key -T copy-mode-vi y \
          send-keys -X copy-pipe-and-cancel "pbcopy"

        bind-key -T copy-mode-vi MouseDragEnd1Pane \
          send-keys -X copy-pipe-and-cancel "pbcopy"
      '';
      plugins = with pkgs; [
        tmuxPlugins.cpu
        tmuxPlugins.nord
        tmuxPlugins.prefix-highlight
        tmuxPlugins.yank
        tmuxPlugins.extrakto
        tmuxPlugins.vim-tmux-navigator
      ];
    };

    programs.alacritty = {
      enable = true;
      settings = {
        shell = {
          program = "${pkgs.zsh}/bin/zsh";
        };
        window_opacity = 0.9;
        live_config_reload = true;
        selection = { save_to_clipboard = true; };
        term = "xterm-256color";

        key_bindings = [
          {
            key = "T";
            mods = "Command";
            chars = "\x016\xe0";
          }
        ];
        font = {
          size = 13;
          normal = {
            family = "Hack Nerd Font";
            style = "Regular";

          };
          bold = {
            family = "Hack Nerd Font";
            style = "Bold";
          };
          italic = {
            family = "Hack Nerd Font";
            style = "Italic";
          };


        };
        colors = {
          primary = {
            background = "0x1e2127";
            foreground = "0xabb2bf";
          };

          cursor = {
            text = "0x2E3440";
            cursor = "0xD8DEE9";
          };

          normal = {

            black = "0x1e2127";
            red = "0xe06c75";
            green = "0x98c379";
            yellow = "0xd19a66";
            blue = "0x61afef";
            magenta = "0xc678dd";
            cyan = "0x56b6c2";
            white = "0xabb2bf";

            # Bright colors
            bright = {
              black = "0x5c6370";
              red = "0xe06c75";
              green = "0x98c379";
              yellow = "0xd19a66";
              blue = "0x61afef";
              magenta = "0xc678dd";
              cyan = "0x56b6c2";
              white = "0xffffff";
            };
          };
        };
      };
    };
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse = "autoraise";
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "off";
      window_opacity_duration = "0.0";
      window_border = "on";
      window_border_placement = "inset";
      window_border_width = 2;
      window_border_radius = 3;
      active_window_border_topmost = "off";
      window_topmost = "on";
      window_shadow = "float";
      active_window_border_color = "0xff5c7e81";
      normal_window_border_color = "0xff505050";
      insert_window_border_color = "0xffd75f5f";
      active_window_opacity = "1.0";
      normal_window_opacity = "1.0";
      split_ratio = "0.50";
      auto_balance = "on";
      mouse_modifier = "fn";
      mouse_action1 = "move";
      mouse_action2 = "resize";
      layout = "bsp";
      top_padding = 5;
      bottom_padding = 10;
      left_padding = 10;
      right_padding = 10;
      window_gap = 10;
    };

    extraConfig = ''
      # rules
      yabai -m rule --add app='System Preferences' manage=off
    '';
  };


  services.nix-daemon.enable = true;
  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableFzfHistory = true;
    enableCompletion = true;
  };

  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
  system.stateVersion = 4;
}
