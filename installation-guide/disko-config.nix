# basic main drive full hybrid (legacy+efi) boot with read-only efi
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = /dev/sda; # please change when on machine
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
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };

          };
        };
      };
    };
  };
}

