{ inputs, pkgs, libs, config, ... }:
{
  imports = [
    # Terminal-related packages
    ./terminal
    ./ssh

    # Gaming-related packages
    ./gaming

    # Editor-related packages
    ./editor

    # Browser-related packages
    ./browser

    # Virtualization-related packages
    ./virtualization

    # Media-related config
    ./media

    # Manually set some dots
    ./configs
  ];

  home.packages = with pkgs; [
    # Applications
    trilium-desktop
    element-desktop

    # Command-line Utilities
    tealdeer
    fzf
    fd
    btop
    bat
    tiv # image viewer
    ripgrep

    # Miscellaneous
    fuzzel

    # File-Managers
    xfce.thunar
    pcmanfm

  ];


  services.easyeffects = {
    enable = true;
    package = pkgs.easyeffects;
  };

  programs.exa = {
    enable = true;
    enableAliases = true;
  };

  programs = {
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
  };

  programs.git = {
    enable = true;
    userEmail = "nixos-git@knoc.one";
    userName = "knoff";
  };


  programs.home-manager.enable = true;
}
