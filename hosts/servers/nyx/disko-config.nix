{
  disko.devices = {
    disk = {

      hdd01 = {
        type = "disk";
	device = "/dev/sda";
	content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
	    "/hdd01" = {
              mountpoint = "/mnt/hdd-pool/hdd01";
              mountOptions = [ "compress=zstd" "noatime" ]; # once a file is on a hdd it shouldn't need atime
	    };
	  };
	};
      };

      ssd01 = {
        type = "disk";
	device = "/dev/sdb";
	content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {
	    "/ssd01" = {
              mountpoint = "/mnt/ssd-pool/ssd01";
              mountOptions = [ "compress=zstd" ]; # need atime for caching mover script
	    };
	  };
	};
      };

      metadata = {
        type = "disk";
        device = "/dev/nvme1n1";
        content = {
          type = "btrfs";
          extraArgs = [ "-f" ];
          subvolumes = {

            "/plex" = {
              mountpoint = "/metadata/plex";
              mountOptions = [ "compress=zstd" "noatime" ];
            };

            "/nextcloud" = {
              mountpoint = "/metadata/nextcloud";
              mountOptions = [ "compress=zstd" "noatime" ];
            };

          };
        };
      };

      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {

            bios = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };

            efi = {
              size = "200M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi";
                mountOptions = [ "ro" ]; # read-only
              };
            };

            boot = {
              size = "1G";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/boot";
              };
            };

            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "/nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                };
              };
            };

          };
        };
      };
    };
  };
}

