{ lib, inputs, outputs, ... }:
{
  imports = [
    ./nix.nix
    ./remove-default-pkgs.nix
  ];
  programs.dconf.enable = true; # needed by easy effects inorder to work

}
