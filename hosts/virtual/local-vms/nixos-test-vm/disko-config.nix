{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
		device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            bios = { # MBR for legacy bios boot
              size = "1M";
              type = "EF02"; 
            };
            efi = { # for UEFI booting
              size = "200M";
              type = "EF00";               
			  content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot/efi"; # boot.loader.efi.efiSysMountPoint = "/boot/efi";
				mountOptions = [ "ro" ]; # read-only to stop accidental modifications
              };
            };
			boot = { # linux boot partition
				size = "1G";
				type = "EF03";
				content = {
					type = "filesystem";
					format = "ext4";
					mountpoint = "/boot"
				};
			};
            root = { # linux OS partition
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
      data1 = {
        type = "disk";
	device = "/dev/vdb";
        content = {
	  type = "gpt";
	  partitions = {
	    data1 = {
	      size = "100%";
	      content = {
	        type = "btrfs";
		extraArgs = [ "-f" ]; # Override existing partition
		subvolumes = {
		  "/data1" = {
		    mountOptions = [ "compress=zstd" ];
		    mountpoint = "/disk-pool/data1";
		  };
		};
	      };
	    };
	  };
	};
      };
      data2 = {
        type = "disk";
	device = "/dev/vdc";
        content = {
	  type = "gpt";
	  partitions = {
	    data2 = {
	      size = "100%";
	      content = {
	        type = "btrfs";
		extraArgs = [ "-f" ]; # Override existing partition
		subvolumes = {
		  "/data2" = {
		    mountOptions = [ "compress=zstd" ];
		    mountpoint = "/disk-pool/data2";
		  };
	        };
	      };
	    };
	  };
	};
      };
      data3 = {
        type = "disk";
	device = "/dev/vdd";
        content = {
	  type = "gpt";
	  partitions = {
	    data3 = {
	      size = "100%";
	      content = {
	        type = "btrfs";
		extraArgs = [ "-f" ]; # Override existing partition
		subvolumes = {
		  "/data3" = {
		    mountOptions = [ "compress=zstd" ];
		    mountpoint = "/disk-pool/data3";
		  };
		  "/data4" = {
		    mountOptions = [ "compress=zstd" ];
		    mountpoint = "/disk-pool/data4";
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

