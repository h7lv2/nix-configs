{ config, pkgs, ... }:
{
  home.username = "eli";
  home.homeDirectory = "/home/eli";

  systemd.user.sessionVariables = { 
    editor = "hx";
  };

  home.pointerCursor = {
    package = pkgs.kdePackages.breeze;
    gtk.enable = true;
    x11.enable = true;
    
    name = "breeze_cursors";
    size = 24;
  };

  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      nil
      llvmPackages_18.clang-tools
      python312Packages.python-lsp-server
      python312Packages.python-lsp-ruff
    ];
    settings = {
      theme = "onedark";
      editor = {
        line-number = "relative";
        mouse = false;
        lsp.display-messages = true;
      };
    };
  };

  programs.ghostty = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      theme = "Breeze";
      background-opacity = 0.85;
      background-blur = true;
    };
  };

  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    settings = {
      themes = {
        breezedark = {
          fg = "#fcfcfc";
          bg = "#232627";
          black = "#232627";
          red = "#ed1515";
          green = "#11d116";
          yellow = "#f67400";
          blue = "#1d99f3";
          magenta = "#9b59b6";
          cyan = "#1abc9c";
          white = "#fcfcfc";  
          orange = "#f0544c";
        };
      };
      theme = "breezedark";
    };
  };

  programs.bash = {
    enable = true;
    sessionVariables = {
      EDITOR = "hx";
    };
  };

  services.syncthing = {
    enable = true;
  };

  # xdg.desktopEntries = {
  #   vesktop = {
  #     name = "Vesktop";
  #     icon = "/$(pkgs.vesktop)/share/icons/hicolor/1024x1024/apps/vesktop.png";
  #     genericName = "Internet Messenger";
  #     exec = "vesktop %U --ozone-platform=wayland";
  #     terminal = false;
  #     categories = [ "Network" "InstantMessaging" "Chat" ];
  #     type = "Application";
  #   };
  # };

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;
}
