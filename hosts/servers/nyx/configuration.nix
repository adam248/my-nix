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

  # Nvidia drivers for P4000
  services.xserver.videoDrivers = [ "nvidia" ];

  # Define on which hard drive you want to install Grub.
  # this is set by disko -> # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nyx"; # Define your hostname.
  networking.domain = "home"; # fqdn = nyx.local
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
    git
    mergerfs
    neofetch
    neovim
    nixpkgs-fmt
    nvme-cli
    smartmontools
    stress-ng
    tldr
    tmux
  ];

  # MergerFS setup fstab entries

  fileSystems."/mnt/hdds" = {
    # "slow" storage disks
    fsType = "fuse.mergerfs";
    device = "/mnt/hdd-pool/*";
    options = [
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mfs"
    ];
  };
  
  fileSystems."/media" = {
    # "fast"+"slow" storage disks
    fsType = "fuse.mergerfs";
    device = "/mnt/ssd-pool/*:/mnt/storage";
    options = [
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=ff"
    ];
  };



  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Security
  security.acme = {
    acceptTerms = true;
    defaults.email = "adjbutler+acme@gmail.com";
    defaults.server = "https://ca.nyx.home";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.nginx.enable = true;
  services.nginx.virtualHosts = {

    "scrutiny.nyx.home" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8111";
      };
    };

    "adguard.nyx.home" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:5353";
      };
    };

    "vault.nyx.home" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };

    "plex.nyx.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
      };
    };

    "cloud.nyx.home" = {
      forceSSL = true;
      enableACME = true;
    };

    "office.nyx.home" = {
      forceSSL = true;
      enableACME = true;
    };

    "ca.nyx.home" = {
      locations."/" = {
        proxyPass = "http://127.0.0.1:8443";
      };
    };

    "prowlarr.nyx.home" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
    };

    "audiobookshelf.nyx.home" = {
      forceSSL = true;
      enableACME = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:8696";
      };
    };

  };

  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8696;
    #dataDir = "/metadata/audiobookshelf";
  };

  # Prowlarr - torrent and usernet indexer and download manager
  services.prowlarr.enable = true;

  # Samba network shares
  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "security" = "user";
      };
      "public" = {
        "path" = "/media";
	"browseable" = "yes";
	"read only" = "yes";
	"guest ok" = "yes";
	"comment" = "Public nyx.home samba share";
      };
      "private" = {
        "path" = "/media";
	"browseable" = "yes";
	"read only" = "no";
	"guest ok" = "no";
	"create mask" = "0644";
	"directory mask" = "0755";
	"force user" = "plex";
	"force group" = "plex";
      };
    };
  };


  # Cert Auth step-ca
  services.step-ca = {
    enable = true;
    intermediatePasswordFile = "/etc/nixos/step-ca-pass";
    address = "127.0.0.1";
    port = 8443;
    openFirewall = true;
    settings = builtins.fromJSON ''

{
	"root": "/root/.step/certs/root_ca.crt",
	"federatedRoots": null,
	"crt": "/root/.step/certs/intermediate_ca.crt",
	"key": "/root/.step/secrets/intermediate_ca_key",
	"address": ":443",
	"insecureAddress": "",
	"dnsNames": [
		"192.168.0.3"
	],
	"logger": {
		"format": "text"
	},
	"db": {
		"type": "badgerv2",
		"dataSource": "/root/.step/db",
		"badgerFileLoadingMode": ""
	},
	"authority": {
		"provisioners": [
			{
				"type": "JWK",
				"name": "adam@nyx.home",
				"key": {
					"use": "sig",
					"kty": "EC",
					"kid": "9tNI0q318tDooHxlfpfuAkqjAzXulllzViRDDcHZies",
					"crv": "P-256",
					"alg": "ES256",
					"x": "SuzG6AIcKC6sP2SO1zfnsYMQ2C5sty7jsb1MUmdb4kM",
					"y": "ygaPJ9fuqQrUQ5o3JmHdpBvwspON0XAeIVtfsLAIYnA"
				},
				"encryptedKey": "eyJhbGciOiJQQkVTMi1IUzI1NitBMTI4S1ciLCJjdHkiOiJqd2sranNvbiIsImVuYyI6IkEyNTZHQ00iLCJwMmMiOjYwMDAwMCwicDJzIjoiX1lrMk9Ud0ZNZldMZVFiMm9ybDhJdyJ9.TD7AknjenWl2QZ75AfLGzv5WdjQjf21nWZL6dDy4CYTtZjhtusXH_A.2OcmrMUnhWk5gOma.9HYvNXo0EdEWOVUNW-uufpsQKRWJzM4zmAJysiSOeneXS0i6VK2eNCTnNvPsocasqJ8Vs2htJTIDVa07ncz8u6tuPEZvHMVmLfSW41-pOM_svB9iDvL4Qgu6ig0JN5h74jGMkBBMFzL2jedt_gk7rmdCm3Vq2i2XkAm98ckNh51cU1WHpkuPuVZ4ofjVyQWlf8eBXyeMcBmV1lFOVyfdUArHBV3FOwLHU4OAQrMUT4YAxB_xD-2zR7C4Q_UVURo8uhwFAJ2fyMR-qhK5eRVynqNcUoodzUIpjVeus1AQ7A7D1OIHatIoGq6bU8LWTQ-E2IYjItDZ7n9K1ylm2PQ.wW3z6_XQWFSsbFxkgm3rEA"
			}
		]
	},
	"tls": {
		"cipherSuites": [
			"TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256",
			"TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
		],
		"minVersion": 1.2,
		"maxVersion": 1.3,
		"renegotiation": false
	}
}
    '';
  };

  # Nextcloud
  services.nextcloud = {
    enable = true;
    hostName = "cloud.nyx.home";

    package = pkgs.nextcloud30;

    database.createLocally = true;

    maxUploadSize = "16G";
    https = true;

    extraApps = with config.services.nextcloud.package.packages.apps; {
      inherit calendar contacts mail notes onlyoffice tasks;
    };

    settings = {
      overwriteprotocol = "https"; 
      default_phone_region = "AU";
    };

    config = {
      dbtype = "pgsql";
      adminuser = "adam";
      adminpassFile = "/metadata/nextcloud/admin-pass";
    };

    home = "/metadata/nextcloud";
  };

  services.onlyoffice = {
    enable = true;
    hostname = "office.nyx.home";
  };

  # Plex
  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/metadata/plex";
    extraPlugins = [
      (builtins.path {
        name = "Audnexus.bundle";
	path = pkgs.fetchFromGitHub {
	  owner = "djdembeck";
	  repo = "Audnexus.bundle";
	  rev = "v1.3.2";
	  sha256 = "sha256-BpwyedIjkXS+bHBsIeCpSoChyWCX5A38ywe71qo3tEI=";
	};
      })
    ];
    extraScanners = [
      (pkgs.fetchFromGitHub {
        owner = "ZeroQI";
	repo = "Absolute-Series-Scanner";
	rev = "048e8001a525ba1c04afda2aa2005feb74709eb8";
	sha256 = "sha256-+j4BiGjB3vAmMYjALI+4SNyj1zlriKE0qaCNQOlmpuY=";
      })
    ];
  };

  # Scrutiny Hard Drive health monitor
  services.scrutiny = {
    enable = true;
    settings.web.listen.port = 8111;
    openFirewall = false;
    collector.enable = true;
  };

  # Adguard Home for DNS management
  services.adguardhome = {
    enable = true;
    port = 5353;
    openFirewall = false;
    #extraArgs = [ "--web-addr 0.0.0.0:5353" ];
    settings = {
      users = [
        {
	  name = "adam";
          password = "$2y$10$Z5gGWWiPccqszk1eV29uv.pNYiuaaDFeaIW2VCXg2UmBrZmPa85zy"; # secure pass
	}
      ];
    };
  };

  # Vaultwarden Password Manager
  services.vaultwarden = {
    enable = true;
    config = {
      ROCKET_ADDRESS = "0.0.0.0";
      ROCKET_PORT = 8222;
    };
  };

  networking.firewall = 
    { 
      enable = true;
      allowedTCPPorts = [
        53 # adguard
	80 # nginx
	443 # nginx
	8080
	#8222
	32469 # plex DLNA server
      ];
      allowedUDPPorts = [
        53 # adguard
        1900 # plex DLNA server
      ];
    };

  networking = {
    interfaces.enp65s0f0.ipv4.addresses = [
      {
        address = "192.168.0.3";
        prefixLength = 24;
      }
    ];
    defaultGateway = "192.168.0.1";
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

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

