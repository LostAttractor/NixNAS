{
  description = "ChaosAttractor's NixNAS Server Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    homelab.url = "github:lostattractor/homelab";
    homelab.inputs.nixpkgs.follows = "nixpkgs";
    bcachefs-tools.url = "github:koverstreet/bcachefs-tools";
    bcachefs-tools.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { nixpkgs, deploy-rs, ... }@inputs:
    let
      user = "lostattractor";
    in
    rec {
      # NAS@PVE2.home.lostattractor.net
      nixosConfigurations."nas@pve2.home.lostattractor.net" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs user;
        };
        modules = [
          ./configuration
          inputs.sops-nix.nixosModules.sops
          (inputs.homelab + "/hardware/kvm/proxmox.nix")
          { networking.hostName = "NAS"; }
          { nixpkgs.overlays = [ (final: prev: { inherit (inputs.bcachefs-tools.packages.${system}) bcachefs-tools; }) ]; }
        ];
      };

      # Deploy-RS Configuration
      deploy = {
        sshUser = "root";
        magicRollback = false;

        nodes."nas@pve2.home.lostattractor.net" = {
          hostname = "nas.home.lostattractor.net";
          profiles.system.path =
            deploy-rs.lib.x86_64-linux.activate.nixos
              nixosConfigurations."nas@pve2.home.lostattractor.net";
        };
      };

      # This is highly advised, and will prevent many possible mistakes
      checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks deploy) deploy-rs.lib;

      hydraJobs = with nixpkgs.lib; {
        nixosConfigurations = mapAttrs' (
          name: config: nameValuePair name config.config.system.build.toplevel
        ) nixosConfigurations;
        image = mapAttrs' (
          name: config: nameValuePair name config.config.system.build.image
        ) nixosConfigurations;
      };
    };
}
