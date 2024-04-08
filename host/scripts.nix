{ pkgs, ... }:

{
  environment.systemPackages = [
    (
      pkgs.writeShellScriptBin
        "nvidia-offload"
        ''
          export __NV_PRIME_RENDER_OFFLOAD=1
          export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
          export __GLX_VENDOR_LIBRARY_NAME=nvidia
          export __VK_LAYER_NV_optimus=NVIDIA_only
          exec "$@"
        ''
    )

    (
      pkgs.writeShellScriptBin
        "uh-brightnessctl"
        ''
          echo aaa
        ''
    )

    (
      pkgs.writeShellScriptBin
        "uh-volumectl"
        ''
          echo bbb
        ''
    )

    (
      pkgs.writeShellScriptBin
        "uh-update"
        ''
          sudo nixos-rebuild switch -v -L --flake /extend/05-person/07-02-nixconfigs/
        ''
    )

    (
      pkgs.writeShellScriptBin
        "uh-upgrade"
        ''
          nix flake update -v -L /extend/05-person/07-02-nixconfigs/ &&
          uh-update
        ''
    )
  ];
}
