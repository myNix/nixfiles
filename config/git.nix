{ writeText, neovim, gnupg }:

let
  self = writeText "config-git"
    ''
    [core]
      editor = ${neovim}/bin/nvim -f

    [user]
      name = mvaude
      email = maxime.vaude@gmail.com

    [color]
      diff = auto
      branch = auto
      status = auto
      interactive = auto
      ui = true

    [diff]
      renames = true

    [merge]
      tool = vimdiff3

    [mergetool]
      path = ${neovim}/bin/nvim

    [alias]
      s = status
      d = diff
      ci = commit -v
      cia = commit -v -a
      co = checkout
      l = log --graph --oneline --decorate --all
      b = branch

    [status]
      submodulesummary = true

    [push]
      default = simple
    '';
in {
  light = self;
  dark = self;
  environment_etc =
    [ { source = self;
        target = "gitconfig";
      }
    ];
  packages = {};
}
