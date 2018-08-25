{ pkgs
, mvaude_config ? null
}:

let

  self = { 

    inherit mvaude_config;

    nixos_slim_theme = pkgs.fetchurl {
      url = "https://github.com/jagajaga/nixos-slim-theme/archive/master.tar.gz";
      sha256 = "0nflmgwdwc7qy0qb3kwg96w0hw7mvxwfx77yrahv8cqbq78k0gl9";
    };

    nix-home = pkgs.callPackage ./nix-home.nix {
      inherit (pkgs) stdenv python fetchFromGithub;
    };

    termite = pkgs.termite.override { configFile = "/tmp/config/termite"; };

    neovim = pkgs.neovim.override {
      vimAlias = true;
      configure = import ./nvim_config.nix {
        inherit pkgs;
        theme = if mvaude_config == null then null else mvaude_config.theme;
      };
    };

  };

in self
