# Nyx

My first rack mounted home media server using NixOS.
It will also be a NAS.

## Networking

- nyx.local
- 192.168.0.3

## Services

- Scrutiny (webui for hard drive health monitoring)
- Plex
- Nextcloud
- Samba
- Vaultwardan (or a good password manager)
- Backups

## Disk Serial Numbers

| NAME | SIZE | SERIAL | TYPE | MOUNTPOINT | PURPOSE | 
|-------|--------|--------|-------|-------|-------| 
| nvme0n1 | 500GB | 190156804976 | NVME SSD | **Operating System** | OS | 
| nvme1n1 | 1TB | S6WSNS0W540637H | NVME SSD | /mnt/metadata | Plex Metadata and other databases for fast webpage loading | 
| sda | 2TB | 2421624A0511 | SATA SSD | /mnt/ssd-pool/ssd1 | Cache for main storage | 
| sdb | 24TB | ZYD0FB93 | SATA HDD | /mnt/hdd-pool/hdd1 | Normal storage | 

## File System Design

Using MergerFS and Snapraid-Btrfs to create a custom flexible NAS.

### Partitions

| NAME | DEVICE | FORMAT | SIZE |
|---|---|---|---|
| MBR       | nvme0n1 |   | 1MB |
| efi       | nvme0n1 | vfat | 200MB |
| boot      | nvme0n1 | vfat  | 1GB |
| root      | nvme0n1 | btrfs | 100% |
| metadata  | nvme1n1 | btrfs  | 100% |
| ssd1 | sda | btrfs | 100% |
| hdd1 | sdb | btrfs | 100% |

### Btrfs Subvolumes

| NAME | PARTITION | MOUNT OPTIONS |
|---|---|---|
| home | root | |
| nix | root | |
| plex | metadata | |

## Network Shares

## User permissions

## Future Tasks

- [ ] setup a dns server (AdguardHome looks good) that supports network-wide ad-blocking (pi-hole is not yet packaged for nixos and doesn't support encrypted dns!!!)
    - see [Pi-hole vs AdguardHome vs Blocky](https://www.youtube.com/watch?v=rfBh2VVOVZA)
- [ ] setup reverse proxy to enable `plex.nyx.local` and `nextcloud.nyx.local` urls
- [ ] research how to automate TRIM for SSDs and NVME in Nixos
- [ ] create a network bond for the 2 onboard NICs for higher bandwidth
    - [Nixos Discourse Topic](https://discourse.nixos.org/t/bonding-interface/18346/6)
- [ ] ZoneMinder camera managment service 
- [ ] eBook library
- [ ] Audio Book library
- [ ] juypter notebooks
