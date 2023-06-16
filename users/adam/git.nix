{
  programs.git = {
    enable = true;
    userName = "adam248";
    userEmail = "adamjbutler091@gmail.com";
    #includes = [ { path = "~/.gitlocalconfig"; } ];
    extraConfig = {
      init = {
        defaultBranch = "master";
      };
    };
  };
}
