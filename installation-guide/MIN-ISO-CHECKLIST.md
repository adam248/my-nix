# Checklist to complete NixOS install from min-iso


- [ ] Set the `nixos` password to allow ssh
- [ ] Copy `shell.nix`, `disko-config.nix` and `configuration.nix` to target machine
    - `scp ./*.nix nixos@targethost:/home/nixos`
- [ ] Run `nix-shell` to download `disko`
- [ ] Run `disko --mode disko ./disko-config.nix`
- [ ] Run `nixos-generate-config --no-filesystems --root /mnt`
- [ ] Either edit `/mnt/etc/nixos/configuration.nix` or replace it
- [ ] Copy `disko-config.nix` to `/mnt/etc/nixos/`
- [ ] Run `nixos-install` and set root password
- [ ] Reboot into the now freshly installed NixOS system
