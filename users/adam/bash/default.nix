{
  programs.bash = {
    enable = true;
    # not sure if this is .bashrc or .profile
    bashrcExtra = builtins.readFile ./.bashrc;
  };
}
