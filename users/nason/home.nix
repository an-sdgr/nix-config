{ pkgs, ... }:

{
  imports = [
    ./sway.nix
  ];

  home.username = "nason";
  home.homeDirectory = "/home/nason";

  programs.git = {
    enable = true;
    userName = "Austin Nason";
    userEmail = "austin.nason@schrodinger.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    terraform
    ansible
    ansible-lint
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
      "editor.fontFamily" = "Jetbrains Mono";
      "editor.fontSize" = 14;
      "terminal.integrated.fontFamily" = "Jetbrains Mono";
      "terminal.integrated.fontSize" = 14;
      "terminal.integrated.scrollback" = 10000;
      "editor.formatOnSave" = true;
      "telemetry.telemetryLevel" = "off";
    };
    extensions = with pkgs.vscode-extensions;
      [
        ms-vscode-remote.remote-ssh
        github.vscode-pull-request-github
        editorconfig.editorconfig
        mkhl.direnv
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "vim";
          publisher = "vscodevim";
          version = "1.25.2";
          sha256 = "sha256-hy2Ks6oRc9io6vfgql9aFGjUiRzBCS4mGdDO3NqIFEg=";
        }
        {
          name = "todo-tree";
          publisher = "Gruntfuggly";
          version = "0.0.215";
          sha256 = "sha256-WK9J6TvmMCLoqeKWh5FVp1mNAXPWVmRvi/iFuLWMylM=";
        }
        {
          name = "ansible";
          publisher = "redhat";
          version = "2.3.74";
          sha256 = "sha256-7zQqdexZxkIJGfG+hBdrPAsZs6p6EetccreT+RsJ7yw=";
        }
        {
          name = "terraform";
          publisher = "hashicorp";
          version = "2.26.1";
          sha256 = "sha256-7DuGFC6tHHAuyfjmOUHS1DLC47TPhap3CI0AmAgEljk=";
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

