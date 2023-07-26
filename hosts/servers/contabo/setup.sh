echo "Installing Legacy BIOS boot on /dev/sda"

echo "Partitioning sda"

parted /dev/sda -- mklabel msdos
parted /dev/sda -- mkpart primary 1MB 100%
parted /dev/sda -- set 1 boot on

echo "Formatting"

mkfs.ext4 -L nixos /dev/sda1

echo "Mounting"

mount /dev/disk/by-label/nixos /mnt

echo "Generate the config"

mkdir -p /mnt/etc/nixos

nixos-generate-config --root /mnt

echo "Please edit /mnt/etc/nixos/configuration.nix"
echo "Once done, use the nixos-install cmd to complete the installation"

