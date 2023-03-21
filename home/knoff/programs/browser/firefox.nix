# NixOS, Firefox, web browser configuration, extensions, custom configuration options, CSS styles
{ nix-colors, config, pkgs, inputs, ... }:
{
  imports = [
    ./profiles/main
    ./profiles/second
  ];

  programs.firefox = {
    enable = true;
  };
}
