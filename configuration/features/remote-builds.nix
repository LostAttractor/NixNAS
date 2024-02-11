_:

{
  # Remote Builds
  nix.buildMachines = [
    {
      hostName = "nixremote@nixbuilder1.home.lostattractor.net";
      systems = ["x86_64-linux" "i686-linux"];
      maxJobs = 1;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "ca-derivations" ];
      mandatoryFeatures = [ ];
    }
    {
      hostName = "nixremote@nixbuilder2.home.lostattractor.net";
      systems = ["x86_64-linux" "i686-linux"];
      maxJobs = 3;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" "ca-derivations" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;
  # optional, useful when the builder has a faster internet connection than yours
  nix.settings.builders-use-substitutes = true;

  # Disallow building on local system
  nix.settings.max-jobs = 0;
}