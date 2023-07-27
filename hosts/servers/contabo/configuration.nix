# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Use the GRUB 2 boot loader.
  boot.loader.grub = {
    enable = true;
    device = "/dev/sda"; # "/dev/sda" or "nodev" for efi only
    configurationLimit = 42;
  };

  # EFI settings
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos-server"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Darwin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    openssh.authorizedKeys.keys = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2LBHfbPz9xU0GlMVS6l8Vg6FN2krBGHZ0sg4KcOVCg5fNLqNSIogUo4izZklmTIbXeFv2HrIoSUnlOsojouhda7jsGqY8aJhELdNAMTql3BiDKZVPmP5JiWZIqn6i+fVtpdKQjgEFY0iZwpxXzVKjz/Uq5XVfAI8bb/Li/7fQvHpNBziHcdGp6nt16T8dLoXZabo2kgpo7dgwzzzgH5ohedKI7Oo3tHXhYKEgXUXJVBVrtM4HxOy9RcJ+hQPB9OLI4O6RTfk8Pl5NTgxxz3lUKoVQyCRsKJkdP4rFWnN5jMoVfH2EoZEAs17KvXYqxvg2qBs72pXDLt1CHOQKFpIF66msGV5wxPs2RjkY+RXchqClFIx3M4KNFAbAh9UQp5ofbx3YO+/Vbv68pf2MNGJoYsO/iMwJmacg5BXb3t7lG5m7xMNU4VKZf55gJVby4dPmU1/NH0q910mwxbOUcquBylHg720Y8FPoHYvQi9nPu4SGdHBc+STRh3XWKYlSjSqBbhHWFYclSAxFUrVeoA4k4nQpPjMsVGs9y8VCpcoeEpMAbCRWk91b9q6OyxVWgdHzqheUiy9So72szPa34HM5iifjyhKZv4cz/BfczoH6JOZ1+1OYMXOmzv+snK0mm8ECukHqs6ELJOIXaoRGEVTlI2AlBuUG/KgCexxk/atTmQ== adam"];
    initialHashedPassword = "$y$j9T$G5B4BVSDmChDcAYG5HElq.$Ivay7Zh.SsMh6NMpqN06PYZoQRtnkl.FJw7t84QY6LA";
    packages = with pkgs; [
      tree
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  # GNU Privacy Guard
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;

    # Require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;

    # Change this to no to disable root login via ssh
    # Make sure to test that the user defined above is working first
    settings.PermitRootLogin = "no";
  };

  # Enable cloud-init daemon.
  #services.cloud-init.network.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}

