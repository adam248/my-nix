# This Is My Personal Nix System Builds

This allows for easy backups of how my computer is built.
If I ever need to build my computer from scratch (again), then I just run 

```shell
nixos-install --flake <github-url>
```

# TODOs

- [ ] setup a universal calendar/task/event management/backups via home-manager
- [ ] Build a simple VM machine first
- [ ] next build a container
- [ ] build a home server
- [ ] build a home NAS box with NixOS

# Dev-log
- 23/06/16: needed to use `nix-env -u --always` to fix the broken home-manager