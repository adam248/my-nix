{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
	device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1M";
              type = "EF02"; # for grub MBR
            };
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            root = {
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
	        type = "filesystem";
		format = "ext4";
		mountpoint = "/disk-pool/data1";
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
	        type = "filesystem";
		format = "ext4";
		mountpoint = "/disk-pool/data2";
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
	        type = "filesystem";
		format = "ext4";
		mountpoint = "/disk-pool/data3";
	      };
	    };
	  };
	};
      };
    };
  };
}

