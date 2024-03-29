{
  description = "ChaosAttractor's NixNAS Server Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    deploy-rs.url = "github:serokell/deploy-rs";
  };

  outputs = { nixpkgs, deploy-rs, ... }: let
    user = "lostattractor";
  in rec {
    # NixNAS@PVE.home.lostattractor.net
    nixosConfigurations."nixnas@pve.home.lostattractor.net" = nixpkgs.lib.nixosSystem {
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

      nodes."nixnas@pve.home.lostattractor.net" = {
        hostname = "nixnas.home.lostattractor.net";
        profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos nixosConfigurations."nixnas@pve.home.lostattractor.net";
      };
    };

    # This is highly advised, and will prevent many possible mistakes
    checks = builtins.mapAttrs (_system: deployLib: deployLib.deployChecks deploy) deploy-rs.lib;

    hydraJobs = {
      nixosConfigurations = nixpkgs.lib.mapAttrs' (name: config:
        nixpkgs.lib.nameValuePair name config.config.system.build.toplevel)
        nixosConfigurations;
    };
  };
}
