{ config, pkgs, lib, ... }:

#with builtins;
#with lib;

{
  home.packages = with pkgs; [
    # sway stuff
    alacritty
    mako # notifications
    swaylock
    swayidle
    wev # xev replacement
    wob # popup bar for sound / screen
    wl-clipboard
    wofi # launcher
    xorg.setxkbmap
    # av
    pamixer
    brightnessctl
  ];

  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";

      terminal = "alacritty";
      menu = "wofi --show run";

      input = {
        "*" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
          repeat_rate = "60";
          repeat_delay = "250";
          xkb_variant = "dvorak";
          xkb_options = "ctrl:nocaps";
        };
      };

      fonts = {
        names = [ "JetBrains Mono" ];
        style = "Monospace";
        size = 12.0;
      };

      window = { titlebar = false; };

      bars = [{
        fonts.size = 15.0;
        command = "waybar";
        position = "bottom";
      }];

      gaps = {
        smartGaps = true;
        inner = 5;
        outer = 5;
      };

      keybindings = {
        "${modifier}+w" = "kill";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";

        "${modifier}+h" = "focus left";
        "${modifier}+l" = "focus right";
        "${modifier}+k" = "focus up";
        "${modifier}+j" = "focus down";
        "${modifier}+Shift+h" = "move left";
        "${modifier}+Shift+l" = "move right";
        "${modifier}+Shift+k" = "move up";
        "${modifier}+Shift+j" = "move down";

        "${modifier}+Return" = "exec alacritty";
        "${modifier}+d" = "exec ${menu}";

        "XF86AudioRaiseVolume" =
          "exec pamixer -ui 2 && pamixer --get-volume > $SWAYSOCK.wob";
        "XF86AudioLowerVolume" =
          "exec pamixer -ud 2 && pamixer --get-volume > $SWAYSOCK.wob";
        # "XF86AudioMute" = "exec pamixer --toggle-mute && ( [ "$(pamixer --get-mute)" = "true" ] && echo 0 > $WOBSOCK ) || pamixer --get-volume > $WOBSOCK";

        "XF86MonBrightnessUp" =
          "exec brightnessctl set +5% | sed -En 's/.*(([0-9]+)%).*/1/p' > $SWAYSOCK.wob";
        "XF86MonBrightnessDown" =
          "exec brightnessctl set 5%- | sed -En 's/.*(([0-9]+)%).*/1/p' > $SWAYSOCK.wob";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+e" =
          "exec swaynag -t warning -m 'Exit?' -b 'yes' 'swaymsg exit'";

        "${modifier}+Shift+space" = "floating toggle";

      };

      startup = [
        {
          always = true;
          command = "set $WOBSOCK $XDG_RUNTIME_DIR/wob.sock";
        }
        {
          always = true;
          command =
            "rm -f $SWAYSOCK.wob && mkfifo $SWAYSOCK.wob && tail -f $SWAYSOCK.wob | wob";
        }
      ];

    };
    extraOptions = [ "--unsupported-gpu" ];
  };

  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [ "eDP-1" ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        modules-center = [ "sway/window" ];
        modules-right = [ "network" "pulseaudio" "battery" "clock" ];

        "sway/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };

        "network" = {
          format-wifi = "{essid} ({signalStrength}%) ";
          format-ethernet = "{ipaddr}/{cidr} ";
          tooltip-format = "{ifname} via {gwaddr} ";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
          format-alt = "{ifname}: {ipaddr}/{cidr}";
        };

        "pulseaudio" = {
          scroll-step = 1;
          format = "{volume}% {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          on-click = "pavucontrol";
        };
      };
    };
  };

  home.pointerCursor = {
    name = "Adwaita";
    package = pkgs.gnome.adwaita-icon-theme;
    size = 24;
    x11 = {
      enable = true;
      defaultCursor = "Adwaita";
    };
  };

  services.swayidle.enable = true;

}
