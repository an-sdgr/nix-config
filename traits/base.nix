# A trait for all boxxen
{ config, pkgs, ... }:

{
  i18n.defaultLocale = "en_US.UTF-8";
  time = {
    timeZone = "America/Los_Angeles";
    hardwareClockInLocalTime = true;
  };

  environment = {
    systemPackages = with pkgs; [
      # Shell utilities
      zsh
      direnv
      nix-direnv
      devbox
      git
      gcc
      jq
      lsof
      htop
      bat
      neovim-remote
      killall
      neovimConfigured
      rnix-lsp
      home-manager
    ];
    #shellAliases = { };
    pathsToLink = [ "/share/nix-direnv" ];
    variables = { EDITOR = "${pkgs.neovimConfigured}/bin/nvim"; };
  };

  programs.zsh.enable = true;

  #programs.bash.interactiveShellInit = ''
  #  eval "$(${pkgs.direnv}/bin/direnv hook bash)"
  #  source "${pkgs.fzf}/share/fzf/key-bindings.bash"
  #  source "${pkgs.fzf}/share/fzf/completion.bash"
  #'';

  security = {
    sudo = {
      wheelNeedsPassword = false;
      extraConfig = ''
        Defaults lecture = never
      '';
    };
  };

  nix = {
    settings.experimental-features = [ "nix-command" "flakes" ];
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  system.stateVersion = "23.05";
}

