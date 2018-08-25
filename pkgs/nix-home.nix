{ stdenv, python, fetchFromGitHub }:
stdenv.mkDerivation rec {
  version = "0.3.3";
  name = "nix-home-${version}";

  src = fetchFromGitHub {
    rev = version;
    repo = "nix-home";
    owner = "myNix";
    sha256 = "a3edbfeb8bbbf67b96bf159737337670f1b0b993";
  };

  patchPhase = ''
    substituteInPlace nix-home --replace "NIXHOME" "$out/nix/lib"
    substituteInPlace nix-build-home --replace "NIXHOME" "$out/nix/lib"
  '';

  installPhase = ''
    # install binary
    mkdir -p $out/bin
    cp nix-home $out/bin
    cp nix-build-home $out/bin
    chmod +x $out/bin/nix-build-home
    chmod +x $out/bin/nix-home

    # install nix-home lib
    mkdir -p $out/nix
    cp -a lib $out/nix
  '';

  meta = {
    homepage = https://github.com/myNix/nix-home;
    description = "Per-user configuration management via Nix";
    licenses = [ stdenv.lib.license.mit ];
    platforms = stdenv.lib.platforms.unix;
    inherit version;
  };
}
