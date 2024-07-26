{
  pkgs,
  user,
  inputs,
  ...
}:

{
  imports = [
    # Sharing
    ./features/sharing/nfs.nix
    ./features/sharing/samba.nix
    # Services
    ./features/services/qbittorrent.nix
    ./features/services/nextcloud.nix
    ./features/services/emby.nix
    # Features
    ./features/cron.nix
    (inputs.homelab + "/features/nginx.nix")
    (inputs.homelab + "/features/network/avahi")
    (inputs.homelab + "/features/nix")
    (inputs.homelab + "/features/fish.nix")
    (inputs.homelab + "/features/telemetry/mdns.nix")
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
    };
  };

  virtualisation.oci-containers.backend = "docker";

  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_26;
    daemon.settings = {
      ipv6 = true;
      fixed-cidr-v6 = "fd00:1::/64";
      experimental = true;
      ip6tables = true;
    };
  };

  # Basic Packages
  environment.systemPackages = with pkgs; [
    htop
    btop
    duf
    gdu
    lsd
    rsync
    ipfs
    iotop
    atuin
  ];

  system.stateVersion = "24.05";
}
