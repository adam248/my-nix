{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # include common wifi drivers used by Macs and (Asus AC68 card need to confirm)
  nixpkgs.config.allowUnfree = true;
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "wl" "rtl8812au" ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ 
    broadcom_sta 
    rtl88xxau-aircrack
  ];

  environment.systemPackages = with pkgs; [ 
    disko
    git
    mergerfs
    neofetch
    neovim
    smartmontools   # for smartctl cmd
    stress          # stress testing cpu, memory, and IO 
    tldr
    tmux            # for reading the manual and editing the config at the same time
  ];

  # enable root ssh access on install
  systemd.services = {
    sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDib7NjQONFsnHSFqGzd1ozleQz3vsJfm9G7l69SHKoXE6jaKYGuz6sL4LLBGsRAT5KjFi5JNznVNKirf7iAwI8Qra+IAnoPwCtZ5ftVs5sv9g+unccZh+R3FyS1fbGfSlqAmFn9v0UNP4mJXEhX2GM4/hw/8Unp0b9fFMDvf56ldvvCENOy6dZVXhsSbDV423DLsKv0GVousebdW+f4Z0vqKC6H6/T/AJRB7WS/NLeXNW+762nOs/aPkEZ17E7Pe1N1H3WZu3jZivIcXfnNsVpu68133aFX8eZPiMRtbeVBh3T1nbeCrdkSE9oi9m9/Q6DahEtG6N/sZha8RLfYaP4srX/9xhMa/iZiexQ/4INFrUxH8DmKjmr1FF8lpsMcIAg6sjBGpx0rjWJ5HslrIxircl7k8rlk6AtPVPmWj9/vdHL2vq9/Tr+kT9LVHw7L0piGoZkI0K7z++ao2TlOBV8M8Jm19NpBBrL12CeK63QySuNGsCb5XCvtasCNRJIkdBa1u7P3qd7XxEakzaO5OAwnzxptNTuYIiQ33BDEzrfOSEs3jJ71EfrMO1bdTnCj2eDsttuUtdV01cIe1M8W85FetaxHJiGdWTD9ngvQPrs9t1Hf0Hipt1n4hZZEpZN0uDqfLJcVOR62cmz7WHMndfmuk+0ko2aZW5IDbW8JYMItQ== adam@nxbx-dsktp"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC2LBHfbPz9xU0GlMVS6l8Vg6FN2krBGHZ0sg4KcOVCg5fNLqNSIogUo4izZklmTIbXeFv2HrIoSUnlOsojouhda7jsGqY8aJhELdNAMTql3BiDKZVPmP5JiWZIqn6i+fVtpdKQjgEFY0iZwpxXzVKjz/Uq5XVfAI8bb/Li/7fQvHpNBziHcdGp6nt16T8dLoXZabo2kgpo7dgwzzzgH5ohedKI7Oo3tHXhYKEgXUXJVBVrtM4HxOy9RcJ+hQPB9OLI4O6RTfk8Pl5NTgxxz3lUKoVQyCRsKJkdP4rFWnN5jMoVfH2EoZEAs17KvXYqxvg2qBs72pXDLt1CHOQKFpIF66msGV5wxPs2RjkY+RXchqClFIx3M4KNFAbAh9UQp5ofbx3YO+/Vbv68pf2MNGJoYsO/iMwJmacg5BXb3t7lG5m7xMNU4VKZf55gJVby4dPmU1/NH0q910mwxbOUcquBylHg720Y8FPoHYvQi9nPu4SGdHBc+STRh3XWKYlSjSqBbhHWFYclSAxFUrVeoA4k4nQpPjMsVGs9y8VCpcoeEpMAbCRWk91b9q6OyxVWgdHzqheUiy9So72szPa34HM5iifjyhKZv4cz/BfczoH6JOZ1+1OYMXOmzv+snK0mm8ECukHqs6ELJOIXaoRGEVTlI2AlBuUG/KgCexxk/atTmQ== adam@nxbx-dsktp"
  ];

  # set passwords for ssh access
  users.users.root.password = pkgs.lib.mkForce "root";
  users.users.root.initialPassword = pkgs.lib.mkForce null;
  users.users.root.hashedPassword = pkgs.lib.mkForce null;
  users.users.root.hashedPasswordFile = pkgs.lib.mkForce null;
  users.users.root.initialHashedPassword = pkgs.lib.mkForce null;
  users.users.nixos.password = pkgs.lib.mkForce "nixos";
  users.users.nixos.initialPassword = pkgs.lib.mkForce null;
  users.users.nixos.hashedPassword = pkgs.lib.mkForce null;
  users.users.nixos.hashedPasswordFile = pkgs.lib.mkForce null;
  users.users.nixos.initialHashedPassword = pkgs.lib.mkForce null;

  networking = {
    # use eth0 network naming format
    usePredictableInterfaceNames = false; # don't need predictable names when installing from live cd

    # set installer default ip
    #interfaces.eth0.ipv4.addresses = [{
    #    address = "192.168.0.33";
    #    prefixLength = 24;
    #}];
    #defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

# TODO: add wireguard vpn autoconnection setup (need server first)
#       this will allow for easy network-based installation (no more finding a monitor & keyboard)
#       this will work behind a NAT as well and remote machines that do not have public ips 
#       or a lack of port forwarding or anywhere you don't control the network

  
  # the default is: "xz -Xdict-size 100%"
  #isoImage.squashfsCompression = "lz4"; # Turn off compression (a smaller write to USB is prefered)
}