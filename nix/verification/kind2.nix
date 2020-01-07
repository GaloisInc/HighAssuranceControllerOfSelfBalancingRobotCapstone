{ stdenv
, fetchFromGitHub
, python3 
, automake
, autoconf
, libtool
, pkgconfig
, autoreconfHook
, ocaml-ng
, smtType ? "Z3"
, enableManPages ? false
, z3
, yices
, cvc4
, texlive  
, lmodern  }:

let
    # the documentation requires a specific LaTeX environment 
    texliveMk = texlive.combine { inherit (texlive) 
                                  scheme-medium 
                                  latexmk 
                                  titlesec 
                                  tabulary 
                                  varwidth 
                                  framed 
                                  wrapfig 
                                  upquote 
                                  capt-of 
                                  needspace 
                                  tocloft 
                                  datetime 
                                  lastpage 
                                  blindtext 
                                  xpatch 
                                  enumitem 
                                  fmtcount; };
in stdenv.mkDerivation {
  
  pname = "kind2";

  # Pulled from development branch
  version = "1.1.0-dev";

  outputs = [ "out" ] ++ stdenv.lib.optional enableManPages "doc";

  src =  fetchFromGitHub {
    owner = "kind2-mc";
    repo = "kind2";
    rev = "96773521641cef2a7962630ff9d11074e38e778a";
    sha256 = "19s7haxzc8ymlqcvxj8rnm6x9nk5c1161ya1c9s2a3rzwq56ammx";
  };

  # Building with -Werror fails, get rid of it
  patches = [ 
    ./czmq-configure.patch
    ./libczmq-configure.patch
    ./sphinx-configure.patch  
 ];

  # Scripts with not Nix compatible shebangs
  preAutoreconf = ''
	patchShebangs ./autogen.sh
	patchShebangs ./ocamlczmq/autogen.sh
	patchShebangs ./ocamlczmq/czmq/version.sh
	patchShebangs ./build.sh
	patchShebangs ./ocamlczmq/build.sh
  '';

  autoreconfPhase = ''
   	runHook preAutoreconf
   	./autogen.sh
  '';

  buildPhase = ''
    mkdir $out
    export CFLAGS="-Wno-format-security"
    ./build.sh --prefix=$out  
  ''
  +stdenv.lib.optionalString enableManPages
  ''
    cd doc/usr
    make all
    cd ../..  
    '';

    postInstall = ""
    +stdenv.lib.optionalString enableManPages 
    ''
      mkdir $doc
      cp -R doc/usr/build/pdf $doc
      cp -R doc/usr/build/html $doc
      cp -R examples $doc 
    '';  

  nativeBuildInputs = [
    pkgconfig
    libtool
    autoconf
    automake
    autoreconfHook
  ];

  buildInputs = [
    ocaml-ng.ocamlPackages_4_04.ocaml
    ocaml-ng.ocamlPackages_4_04.findlib
    ocaml-ng.ocamlPackages_4_04.ocamlbuild
    ocaml-ng.ocamlPackages_4_04.menhir
    ocaml-ng.ocamlPackages_4_04.num
    ocaml-ng.ocamlPackages_4_04.yojson
    z3
    cvc4
    yices
  ] 
  ++ stdenv.lib.optional enableManPages [ 
    python3 
    python3.pkgs.sphinx 
    texliveMk
    lmodern
  ];
}

