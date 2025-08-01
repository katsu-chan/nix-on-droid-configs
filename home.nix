{ config, lib, pkgs, ... }:

{
  # Read the changelog before changing this value
  home.stateVersion = "24.05";

  # insert home-manager config

  programs = {
    gh.enable = true;

    hyfetch = {
      enable = true;
      settings = {
          preset = "lesbian";
          mode = "rgb";
          light_dark = "dark";
          lightness = 0.6;
          color_align = {
            mode = "horizontal";
            custom_colors = [];
            fore_back = null;
          };
          backend = "neofetch";
          args = null;
          distro = "nixos";
          pride_month_shown = [];
          pride_month_disable = false;
      };
    };
    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      shellAliases = {
        #ll = "ls -l";
        Update = "nix-on-droid switch --flake ~/.config/nix-on-droid";
      };
      history.size = 10000;
    
      oh-my-zsh = { # "ohMyZsh" without Home Manager
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
    };
  };
  home.packages = with pkgs; [
    (writeScriptBin "Nixedit" ''
      #!/bin/zsh
      _Nixedit_completion() {
        local -a options
        options=($(ls ~/.config/nix-on-droid/*.nix))

        _describe 'files and directories' options
      }

      compdef _Nixedit_completion $0

      "$EDITOR" ~/.config/nix-on-droid/"$1"
    '')
  ];   
}                                                                                                                                                                        
