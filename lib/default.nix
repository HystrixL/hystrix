{ lib, pkgs, ... }: {
  scanPaths = path:
    builtins.map
      (f: (path + "/${f}"))
      (builtins.attrNames
        (lib.attrsets.filterAttrs
          (
            path: _type:
              (_type == "directory") # include directories
              || (
                (path != "default.nix") # ignore default.nix
                && (lib.strings.hasSuffix ".nix" path) # include .nix files
              )
          )
          (builtins.readDir path)));

  wrapElectron = { pkgName, binName }:
    pkgs.symlinkJoin {
      name = pkgName;
      paths = [ pkgs.${pkgName} ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = lib.strings.concatStrings [
        "wrapProgram $out/bin/"
        binName
        " --add-flags \"--ozone-platform-hint=auto\""
        " --add-flags \"--enable-webrtc-pipewire-capturer\""
        " --add-flags \"--enable-features=WaylandWindowDecorations\""
        " --add-flags \"--enable-wayland-ime\""
      ];
    };

}
