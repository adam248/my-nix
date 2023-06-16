{
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_rsa_github";
        identitiesOnly = true;
      };
    };
  };
}
