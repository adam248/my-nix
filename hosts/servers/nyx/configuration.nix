# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${builtins.fetchTarball "https://github.com/nix-community/disko/archive/master.tar.gz"}/module.nix"
      ./disko-config.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # Define on which hard drive you want to install Grub.
  # this is set by disko -> # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nyx"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone and locale.
  i18n.defaultLocale = "en_AU.UTF-8";
  time.timeZone = "Australia/Perth";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.adam = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDib7NjQONFsnHSFqGzd1ozleQz3vsJfm9G7l69SHKoXE6jaKYGuz6sL4LLBGsRAT5KjFi5JNznVNKirf7iAwI8Qra+IAnoPwCtZ5ftVs5sv9g+unccZh+R3FyS1fbGfSlqAmFn9v0UNP4mJXEhX2GM4/hw/8Unp0b9fFMDvf56ldvvCENOy6dZVXhsSbDV423DLsKv0GVousebdW+f4Z0vqKC6H6/T/AJRB7WS/NLeXNW+762nOs/aPkEZ17E7Pe1N1H3WZu3jZivIcXfnNsVpu68133aFX8eZPiMRtbeVBh3T1nbeCrdkSE9oi9m9/Q6DahEtG6N/sZha8RLfYaP4srX/9xhMa/iZiexQ/4INFrUxH8DmKjmr1FF8lpsMcIAg6sjBGpx0rjWJ5HslrIxircl7k8rlk6AtPVPmWj9/vdHL2vq9/Tr+kT9LVHw7L0piGoZkI0K7z++ao2TlOBV8M8Jm19NpBBrL12CeK63QySuNGsCb5XCvtasCNRJIkdBa1u7P3qd7XxEakzaO5OAwnzxptNTuYIiQ33BDEzrfOSEs3jJ71EfrMO1bdTnCj2eDsttuUtdV01cIe1M8W85FetaxHJiGdWTD9ngvQPrs9t1Hf0Hipt1n4hZZEpZN0uDqfLJcVOR62cmz7WHMndfmuk+0ko2aZW5IDbW8JYMItQ== adam@nxbx-dsktp"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2LBHfbPz9xU0GlMVS6l8Vg6FN2krBGHZ0sg4KcOVCg5fNLqNSIogUo4izZklmTIbXeFv2HrIoSUnlOsojouhda7jsGqY8aJhELdNAMTql3BiDKZVPmP5JiWZIqn6i+fVtpdKQjgEFY0iZwpxXzVKjz/Uq5XVfAI8bb/Li/7fQvHpNBziHcdGp6nt16T8dLoXZabo2kgpo7dgwzzzgH5ohedKI7Oo3tHXhYKEgXUXJVBVrtM4HxOy9RcJ+hQPB9OLI4O6RTfk8Pl5NTgxxz3lUKoVQyCRsKJkdP4rFWnN5jMoVfH2EoZEAs17KvXYqxvg2qBs72pXDLt1CHOQKFpIF66msGV5wxPs2RjkY+RXchqClFIx3M4KNFAbAh9UQp5ofbx3YO+/Vbv68pf2MNGJoYsO/iMwJmacg5BXb3t7lG5m7xMNU4VKZf55gJVby4dPmU1/NH0q910mwxbOUcquBylHg720Y8FPoHYvQi9nPu4SGdHBc+STRh3XWKYlSjSqBbhHWFYclSAxFUrVeoA4k4nQpPjMsVGs9y8VCpcoeEpMAbCRWk91b9q6OyxVWgdHzqheUiy9So72szPa34HM5iifjyhKZv4cz/BfczoH6JOZ1+1OYMXOmzv+snK0mm8ECukHqs6ELJOIXaoRGEVTlI2AlBuUG/KgCexxk/atTmQ== adam@nxbx-dsktp"
  ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    disko
    mergerfs
    neovim
    tldr
  ];

  # MergerFS setup fstab entries

#  fileSystems."/storage" = {
#    # "slow" storage disks
#    fsType = "fuse.mergerfs";
#    device = "/mnt/hdd-pool/*";
#    options = [
#      "cache.files=partial"
#      "dropcacheonclose=true"
#      "category.create=mfs"
#    ];
#  };
#
#  fileSystems."/media" = {
#    # "fast"+"slow" storage disks
#    fsType = "fuse.mergerfs";
#    device = "/mnt/ssd-pool/*:/storage";
#    options = [
#      "cache.files=partial"
#      "dropcacheonclose=true"
#      "category.create=ff"
#    ];
#  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Scrutiny Hard Drive health monitor
  services.scrutiny.enable = true; # port 8080 # hard drive health webui
  services.scrutiny.openFirewall = true; # port 8080 # hard drive health webui

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

