{ config, pkgs, ... }:
{
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  # include common wifi driver used by Macs and (Asus AC68 card need to confirm)
  nixpkgs.config.allowUnfree = true;
  boot.initrd.kernelModules = [ "wl" ];
  boot.kernelModules = [ "wl" ];
  boot.extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];

  environment.systemPackages = with pkgs; [ 
    disko
    git
    neofetch
    neovim 
    stress
    tldr
    mergerfs
  ];

  systemd.services = {
    sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  };
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDib7NjQONFsnHSFqGzd1ozleQz3vsJfm9G7l69SHKoXE6jaKYGuz6sL4LLBGsRAT5KjFi5JNznVNKirf7iAwI8Qra+IAnoPwCtZ5ftVs5sv9g+unccZh+R3FyS1fbGfSlqAmFn9v0UNP4mJXEhX2GM4/hw/8Unp0b9fFMDvf56ldvvCENOy6dZVXhsSbDV423DLsKv0GVousebdW+f4Z0vqKC6H6/T/AJRB7WS/NLeXNW+762nOs/aPkEZ17E7Pe1N1H3WZu3jZivIcXfnNsVpu68133aFX8eZPiMRtbeVBh3T1nbeCrdkSE9oi9m9/Q6DahEtG6N/sZha8RLfYaP4srX/9xhMa/iZiexQ/4INFrUxH8DmKjmr1FF8lpsMcIAg6sjBGpx0rjWJ5HslrIxircl7k8rlk6AtPVPmWj9/vdHL2vq9/Tr+kT9LVHw7L0piGoZkI0K7z++ao2TlOBV8M8Jm19NpBBrL12CeK63QySuNGsCb5XCvtasCNRJIkdBa1u7P3qd7XxEakzaO5OAwnzxptNTuYIiQ33BDEzrfOSEs3jJ71EfrMO1bdTnCj2eDsttuUtdV01cIe1M8W85FetaxHJiGdWTD9ngvQPrs9t1Hf0Hipt1n4hZZEpZN0uDqfLJcVOR62cmz7WHMndfmuk+0ko2aZW5IDbW8JYMItQ== adam@nxbx-dsktp"
  ];

#  networking = {
#    usePredictableInterfaceNames = false;
#    interfaces.eth0.ipv4.addresses = [{
#        address = "192.168.0.10";
#        prefixLength = 24;
#    }];
#    defaultGateway = "192.168.0.1";
#    nameservers = [ "1.1.1.1" "8.8.8.8" ];
#  };

  isoImage.squashfsCompression = "lz4";
}