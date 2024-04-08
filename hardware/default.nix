{ lib, ... }: {
  imports = [
    ./overlay.nix
    ./hardware-configuration.nix
  ];
}
