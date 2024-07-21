{
  description = "ChaosAttractor's NixNAS Server Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, deploy-rs, ... }: let
    user = "lostattractor";
  in rec {
    # NixNAS@PVE2.home.lostattractor.net
    nixosConfigurations."nixnas@pve2.home.lostattractor.net" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit user; };
      modules = [
        ./hardware/lxc
        ./configuration
        { networking.hostName = "NixNAS"; }
      ];
    };

    # Deploy-RS Configuration
    deploy = {
      sshUser = "root";
      magicRollback = false;

      nodes."nixnas@pve2.home.lostattractor.net" = {
        hostname = "nixnas.home.lostattractor.net";
        profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations."nixnas@pve2.home.lostattractor.net";
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks deploy) deploy-rs.lib;

    hydraJobs = with nixpkgs.lib; {
      nixosConfigurations = mapAttrs' (name: config:
        nameValuePair name config.config.system.build.toplevel)
        nixosConfigurations;
    };
  };
}
