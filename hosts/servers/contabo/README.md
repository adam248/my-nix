# This directory holds all the setup files for my contabo server

Please see the Obsidian notes on NixOS manual installation and ssh key creation.

# Setup ssh

Set the root password then you can login via ssh (allowing the copying of files from your local system)

```
scp setup.sh nixos@172.105.10.184:~
```

# Run install.sh

# Do the changes in *configuration.nix

You can copy over the configuration either via wget (from a URL) or scp (from a local file)

