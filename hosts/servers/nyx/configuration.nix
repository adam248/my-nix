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

  users.groups.media = {};

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
  # no longer needed because I made my own wildcard crt at /etc/nginx/certs/nyx.home.crt
  #security.acme = {
  #  acceptTerms = false;
  #  defaults.email = "adjbutler+acme@gmail.com";
  #  defaults.server = "http://ca.nyx.home";
  #};

  # List services that you want to enable:

  # rabbitmq was running and failing at each build for an unknown reason
  # so I have manually disabled it here
  services.rabbitmq.enable = false;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  services.nginx.enable = true;
  services.nginx.virtualHosts = {

    "scrutiny.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8111";
      };
    };

    "adguard.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:5353";
      };
    };

    "vault.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8222";
      };
    };

    "plex.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:32400";
      };
    };

    "cloud.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";
    };

    "office.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";
    };

    "prowlarr.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:9696";
      };
    };

    "sonarr.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8989";
      };
    };

    "radarr.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:7878";
      };
    };

    "lidarr.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8686";
      };
    };

    "readarr.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8787";
      };
    };

    "audiobookshelf.nyx.home" = {
      # force HTTPS
      forceSSL = true;
      sslCertificate = "/etc/nginx/certs/nyx.home.crt";
      sslCertificateKey = "/etc/nginx/certs/nyx.home.key";

      locations."/" = {
        proxyPass = "http://127.0.0.1:8696";
      };
    };

  };

  # Audiobookshelf
  services.audiobookshelf = {
    enable = true;
    port = 8696;
    #changing this dataDir from the default seems to break audiobookshelf?
    #dataDir = "/metadata/audiobookshelf";
    group = "media";
  };

  # The Arr Suite
  services.prowlarr.enable = true; 	    # Prowlarr - torrent and usernet indexer and download manager
  services.sonarr.enable = true; 	    # Sonarr - Series (TV/Anime/Shows) automatic downloader
  services.radarr.enable = true; 	    # Radarr - Movies/Films automatic downloader
  services.lidarr.enable = true; 	    # Lidarr - Music automatic downloader
  services.readarr.enable = true; 	    # Readarr - Books automatic downloader
  services.bazarr.enable = true;       # Bazarr - Subtitle automatic downloader for Sonarr & Radarr

  # Arr apps not available on nixos yet
  #services.tdarr.enable = false;  	    # Tdarr - automatic transcoder
  #services.mylar3.enable = false;      # Mylar3 - Comics downloader

  # Arr apps I will not use
  #services.ombi.enable = false;   	# Ombi - simple request movies/tv shows web app

  services.sonarr = {
    dataDir = "/metadata/sonarr";
    group = "media";
  };
  services.radarr = {
    dataDir = "/metadata/radarr";
    group = "media";
  };
  services.lidarr = {
    dataDir = "/metadata/lidarr";
    group = "media";
  };
  services.readarr = {
    dataDir = "/metadata/readarr";
    group = "media";
  };


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
	"force group" = "media";
      };
    };
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
    group = "media";
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
    hosts = { 
      "192.168.0.1" = [ "router.home" ];
      "192.168.0.3" = [ "nyx.home" "cloud.nyx.home" ]; 
    };
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

