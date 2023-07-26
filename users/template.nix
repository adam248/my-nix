# this is a template user config
# PLEASE! make a copy before EDITING!
# make sure to add to default.nix imports = [];
# when finished editing

let
    user-name = "joe";

in {
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.${user-name} = {
        isNormalUser = true;
        extraGroups = [
            "wheel" # wheel enables sudo for this user 
        ];
        initialPassword = user-name;
        packages = with pkgs; [

        ];
    };

    home-manager.users.${user-name} = { pkgs, ... }: {
    home.stateVersion = "23.05";
    home.packages = with pkgs; [
        typst
    ];
}