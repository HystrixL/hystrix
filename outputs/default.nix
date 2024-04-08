{ self, nixpkgs, ... } @inputs: {
  nixosConfigurations.hixs = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = { inherit inputs; };
    modules = [
      ./hixs.nix
      inputs.impermanence.nixosModules.impermanence
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;

        home-manager.users.hil.imports = [ ../home ];
        home-manager.extraSpecialArgs = inputs;
      }
    ];
  };
}
