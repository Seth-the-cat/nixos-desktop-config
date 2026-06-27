{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    noctalia = {
      url = "github:noctalia-dev/noctalia";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    #snekstudio = {
      #url = "github:the-furry-hubofeverything/SnekStudio/nix-flake";
      # flake = true;
    #};

    # ADD THIS
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, nix-cachyos-kernel, aagl, noctalia, home-manager, ... }@inputs:
  {
    nixosConfigurations.seththecat = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };  # <-- this is what makes inputs available in hardware.nix
      modules = [
         ./hardware.nix
         ./configuration.nix
         ...
      ];
    };
    homeConfigurations."seththecat@seththecat" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      extraSpecialArgs = { inherit inputs; };
      modules = [ ./home/home.nix ];
    };
  };
}
