{ config, pkgs, ... }: {
  imports = [
    (builtins.fetchTarball {
      # Pick a release version you are interested in and set its hash, e.g.
      url = "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/nixos-23.05/nixos-mailserver-nixos-23.05.tar.gz";
      # To get the sha256 of the nixos-mailserver tarball, we can use the nix-prefetch-url command:
      # release="nixos-23.05"; nix-prefetch-url "https://gitlab.com/simple-nixos-mailserver/nixos-mailserver/-/archive/${release}/nixos-mailserver-${release}.tar.gz" --unpack
      sha256 = "sha256:1ngil2shzkf61qxiqw11awyl81cr7ks2kv3r3k243zz7v2xakm5c";
    })
  ];

  mailserver = {
    enable = true;
    fqdn = "mail.electrovive.com.au";
    domains = [ "electrovive.com.au" ];

    # A list of all login accounts. To create the password hashes, use
    # nix-shell -p mkpasswd --run 'mkpasswd -sm bcrypt'
    loginAccounts = {
      "adam@electrovive.com.au" = {
        hashedPassword = "$2b$05$Hc9Tp.tOHawDCidOH5eTcuYooFc88iFJft6NXTOG.xEeivVAwz.ES";
        aliases = [ "postmaster@electrovive.com.au" ];
        catchAll = [ "electrovive.com.au" ];
      };
      "test@electrovive.com.au" = { 
        hashedPassword = "$2b$05$Hc9Tp.tOHawDCidOH5eTcuYooFc88iFJft6NXTOG.xEeivVAwz.ES";
        aliases = [ "alice@electrovive.com.au" ];
       };
    };

    # Use Let's Encrypt certificates. Note that this needs to set up a stripped
    # down nginx and opens port 80.
    certificateScheme = "acme-nginx";
  };
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "security@electrovive.com.au";
}
