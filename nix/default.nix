let
  pkgs = import <nixpkgs> {};
in 
  pkgs.callPackage ./verification/kind2.nix {}
