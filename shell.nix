{ nixpkgs ? import <nixpkgs> {}, compiler ? "ghc7102" }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, base, containers, descriptive, directory
      , ghc-prim, haskell-src-exts, hspec, monad-loops, mtl, stdenv, text
      , transformers
      }:
      mkDerivation {
        pname = "hindent";
        version = "4.6.3";
        src = ./.;
        isLibrary = true;
        isExecutable = true;
        libraryHaskellDepends = [
          base containers haskell-src-exts monad-loops mtl text transformers
        ];
        executableHaskellDepends = [
          base descriptive directory ghc-prim haskell-src-exts text
        ];
        testHaskellDepends = [
          base directory haskell-src-exts hspec monad-loops mtl text
        ];
        homepage = "http://www.github.com/chrisdone/hindent";
        description = "Extensible Haskell pretty printer";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  drv = haskellPackages.callPackage f {};

in

  if pkgs.lib.inNixShell then drv.env else drv
