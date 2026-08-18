{
  description = "Configuración unificada de NixOS y Home Manager";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    playit-nixos-module.url = "github:pedorich-n/playit-nixos-module";
  };
  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      playit-nixos-module,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        escritorio = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/escritorio/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            playit-nixos-module.nixosModules.default
          ];
        };

        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            ./configuration.nix
            ./hosts/laptop/hardware-configuration.nix
            home-manager.nixosModules.home-manager
            playit-nixos-module.nixosModules.default
          ];
        };
      };
    };
}
