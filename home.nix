{ pkgs, prefix, ... }:

let
  my-dotfiles-dir = "./config";
in {
   home-manager.users.maxter = {
     programs.chromium.enable = true;
     home.file.".tmux.conf".source = ./config/tmux.conf;
   };
}
