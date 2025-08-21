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

      envExtra = ''
        export ZSH_MOTD_CUSTOM="$(cat ~/.motd)"
      '';

      shellAliases = {
        #ll = "ls -l";
        Update = "nix-on-droid switch --flake ~/.config/nix-on-droid";
      };
      history.size = 10000;

      plugins = [
	{
          # will source zsh-motd.plugin.zsh
          name = "zsh-motd";
	  # TODO: rewrite to use runCommand
	  src = pkgs.stdenvNoCC.mkDerivation rec {
	    name = "zsh-motd-patched";
	    patches = [
              (pkgs.writeText "inline-patch" ''
diff -u a/zsh-motd.plugin.zsh b/zsh-motd.plugin.zsh
--- a/zsh-motd.plugin.zsh	1970-01-01 03:00:01.000000000 +0300
+++ b/zsh-motd.plugin.zsh	2025-08-21 03:00:50.304828222 +0300
@@ -5,7 +5,7 @@
 
 # Make sure perl is installed. It usually is, but just in case
 PERL_INSTALLED=0
-if hash perl; then
+if [ -z "$(hash perl 2>&1)" ]; then
     PERL_INSTALLED=1
 fi 
              '')
            ];
	    src = pkgs.fetchFromGitHub {
              owner = "Kallahan23";
              repo = "zsh-motd";
              rev = "ca31aba23f94255b3d6d17e7905ca42fd599c93c";
	      hash = "sha256-/DaiEZ5ZBs6WStNl0/VVpYliJm6j86FTEQWUPrcGlAI=";
            }; 
	    installPhase = ''
              mkdir -p $out
	      cp -r * $out/
	    '';
          };
	}
      ];

      oh-my-zsh = { # "ohMyZsh" without Home Manager
        enable = true;
        plugins = [ "git" "thefuck" ];
        theme = "robbyrussell";
      };
    };
  };
  home.packages = with pkgs; [
    perl
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
