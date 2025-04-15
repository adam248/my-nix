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

    };
  };
}

