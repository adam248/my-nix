# Custom NixOS ISOs

[NixOS Wiki Guide](https://nixos.wiki/wiki/Creating_a_NixOS_live_CD)

Make a NixOS ISO that has packages pre-loaded on it.

## Build command

`nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix`


## Enable SSH

```
{
  # Enable SSH in the boot process.
  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AaAexxxxx...eeeeeee username@host"
  ];
}
```


## Skipping Compression

Just add this to `iso.nix`

```
{
  isoImage.squashfsCompression = "gzip -Xcompression-level 1";
}
```