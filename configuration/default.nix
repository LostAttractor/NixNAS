{
  pkgs,
  lib,
  user,
  inputs,
  config,
  ...
}:

{
  imports = [
    # Sharing
    ./features/sharing/nfs.nix
    ./features/sharing/samba.nix
    # Services
    ./features/services/syncthing.nix
    ./features/services/qbittorrent.nix
    ./features/services/nextcloud.nix
    ./features/services/emby.nix
    ./features/services/immich.nix
    # Features
    ./features/snapper.nix
    ./features/cron.nix
    (inputs.homelab + "/features/basic.nix")
    (inputs.homelab + "/features/nix")
    (inputs.homelab + "/features/fish.nix")
    (import (inputs.homelab + "/features/telemetry") ({ inherit config; promtail_password_file = config.sops.secrets.promtail.path; }))
    (inputs.homelab + "/features/time.nix")
    (inputs.homelab + "/features/nginx.nix")
    (inputs.homelab + "/features/network/avahi")
  ];

  users = {
    # Don't allow mutation of users outside of the config.
    mutableUsers = false;
    # Privilege User
    users.root.openssh.authorizedKeys.keys = [
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC5HypvbsI4xvwfd4Uw7D+SV0AevYPS/nCarFwfBwrMHKybbqUJV1cLM1ySZPxXcZD7+3m48Riiwlssh6o7WM/M= openpgp:0xDE4C24F6"
    ];
    # Unprivilege User
    users.${user} = {
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBC5HypvbsI4xvwfd4Uw7D+SV0AevYPS/nCarFwfBwrMHKybbqUJV1cLM1ySZPxXcZD7+3m48Riiwlssh6o7WM/M= openpgp:0xDE4C24F6"
      ];
      extraGroups = [ "wheel" "docker" ];
    };
  };

  security.sudo.wheelNeedsPassword = false;

  networking.nftables.enable = true;

  virtualisation = {
    oci-containers.backend = "docker";
    docker = {
      enable = true;
      package = pkgs.docker_26;
      daemon.settings = {
        ipv6 = true;
        fixed-cidr-v6 = "fd00:1::/64";
        experimental = true;
        ip6tables = true;
      };
    };
  };

  boot.kernel.sysctl."vm.overcommit_memory" = true;

  # Enable Swap
  swapDevices = lib.mkForce [ {
    device = "/var/lib/swapfile";
    size = 8*1024;
  } ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.supportedFilesystems = [ "bcachefs" ];

  fileSystems."/mnt" = {
    device = "/dev/disk/by-uuid/bab87dfe-4491-4144-a16a-a8ce549f8dca";
    fsType = "bcachefs";
  };

  # Basic Packages
  environment.systemPackages = with pkgs; [
    rsync
    ipfs
    iotop
  ];

  sops.defaultSopsFile = ../secrets.yaml;
  sops.secrets.promtail.owner = "promtail";

  system.stateVersion = "24.11";
}
