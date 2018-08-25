{ pkgs, prefix, ... }:

{
   home-manager.users.maxter = {
     programs.chromium.enable = true;
   };
}
