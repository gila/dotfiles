{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    rustup
    fd
    k9s
    mosh
    ripgrep
  ];

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
      onedark-nvim
      packer-nvim
      plenary-nvim
      telescope-nvim
      vim-vsnip
      colorizer
      whitespace-nvim
      rust-tools-nvim
    ];

    extraPackages = with pkgs; [
      rust-analyzer
      rnix-lsp
      gopls
      black
      lua-language-server
      luaformatter
      nixpkgs-fmt
      pyright
      stylua
      yamlfix
    ];

    extraConfig = ''
      :luafile ~/.config/nvim/lua/init.lua
    '';
  };

  xdg.configFile.nvim = {
    source = ./lua;
    recursive = true;
  };

  programs.go.enable = true;

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
    enableBashIntegration = true;
    defaultOptions = ["--height 40%" "--layout=reverse" "--border" "--inline-info"];
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    defaultKeymap = "viins";
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      save = 50000;
      share = true;
    };

    shellAliases = {
      ls = "${pkgs.exa}/bin/exa --group-directories-first";
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

    oh-my-zsh = {
      theme = "duellj";
      enable = true;
      plugins = [
        "colored-man-pages"
        "command-not-found"
        "docker"
        "extract"
        "fzf"
        "git"
        "kubectl"
        "man"
        "systemd"
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
    terminal = "xterm-256color";
    historyLimit = 5000000;
    plugins = with pkgs; [
      tmuxPlugins.cpu
      tmuxPlugins.nord
      tmuxPlugins.prefix-highlight
      tmuxPlugins.yank
    ];
    extraConfig = ''
      bind -r k select-pane -U
      bind -r j select-pane -D
      bind -r h select-pane -L
      bind -r l select-pane -R
    '';
  };

  home.file = {};

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.home-manager.enable = true;
}
