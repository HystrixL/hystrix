{ lib,pkgs,hlib, ... }:
let
hlib = import ../lib { inherit lib pkgs; }
  ;
in
{
  imports = (hlib.scanPaths ./.);
}
