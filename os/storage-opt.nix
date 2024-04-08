{ config, lib, pkgs, inputs, ... }:
{
  nix.optimise.automatic = true;
  nix.optimise.dates = [ "20:24" ];
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
