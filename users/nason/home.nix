{ config, pkgs, lib, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.username = "nason";
  home.homeDirectory = "/home/nason";

  programs.git = {
    enable = true;
    userName = "Austin Nason";
    userEmail = "austin.nason@gmail.com";
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })

  ];

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableVteIntegration = true;
    initExtra = ''
      export XKB_DEFAULT_LAYOUT=dvorak
    '';

    plugins = [
      {
        name = "zsh-autosuggestions";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-autosuggestions";
          rev = "v0.7.0";
          sha256 = "sha256-KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
        };
      }
      {
        name = "liquidprompt";
        src = pkgs.fetchFromGitHub {
          owner = "nojhan";
          repo = "liquidprompt";
          rev = "v2.1.2";
          sha256 = "sha256-7mnrXLqnCdOuS2aRs4tVLfO8SRFrqZHNM40gWE/CVFI=";
        };
      }
    ];
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    userSettings = {
      "workbench.colorTheme" = "Palenight Operator";
      "terminal.integrated.scrollback" = 10000;
      "editor.formatOnSave" = true;
    };
    extensions = with pkgs.vscode-extensions;
      [
        ms-vscode-remote.remote-ssh
        github.vscode-pull-request-github
        editorconfig.editorconfig
        mkhl.direnv
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "material-palenight-theme";
          publisher = "whizkydee";
          version = "2.0.2";
          sha256 = "sha256-//EpXe+kKloqbMIZ8kstUKdYB490tQBBilB3Z9FfBNI=";
        }
        {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.215";
          sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
        }
      ] ++ (if pkgs.stdenv.isx86_64 then
        with pkgs.vscode-extensions; [ ms-python.python ]
      else
        [ ]);
  };

  programs.home-manager.enable = true;
  programs.alacritty.enable = true;
  home.stateVersion = "23.05";
}

