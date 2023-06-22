# A trait for all boxxen
{ config, pkgs, ... }:

{
    time.timeZone = "America/Los_Angeles";
    # Windows wants hardware clock in local time instead of UTC
    time.hardwareClockInLocalTime = true;

    i18n.defaultLocale = "en_US.UTF-8";

    environment.systemPackages = with pkgs; [
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
    ];
    #environment.shellAliases = { };
    environment.variables = { EDITOR = "${pkgs.neovimConfigured}/bin/nvim"; };
    environment.pathsToLink = [ "/share/nix-direnv" ];

    programs.zsh.enable = true;

    #programs.bash.interactiveShellInit = ''
    #  eval "$(${pkgs.direnv}/bin/direnv hook bash)"
    #  source "${pkgs.fzf}/share/fzf/key-bindings.bash"
    #  source "${pkgs.fzf}/share/fzf/completion.bash"
    #'';

    security.sudo.wheelNeedsPassword = false;
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    nix.extraOptions = ''
      experimental-features = nix-command flakes
    '';

    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    #nix.package = pkgs.nixUnstable;

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;

    nixpkgs.config.allowUnfree = true;

    system.stateVersion = "23.05";
}

