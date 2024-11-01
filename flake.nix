{
  description = "hakyll flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
  };

  outputs =
    { nixpkgs, systems, ... }:
    let
      # Only care about actual Haskell source files; improves caching behaviour
      haskellSourceFilter =
        src:
        nixpkgs.lib.cleanSourceWith {
          inherit src;
          filter =
            name: type:
            let
              file = toString name;
              baseName = baseNameOf file;
            in
            nixpkgs.lib.cleanSourceFilter name type
            && (
              nixpkgs.lib.hasPrefix "src" baseName
              || nixpkgs.lib.hasSuffix ".cabal" file
              || nixpkgs.lib.hasSuffix ".project" file
              || nixpkgs.lib.hasSuffix ".hs" file
              || nixpkgs.lib.hasSuffix ".nix" file
            );
        };

      supportedSystems = import systems;

      forAllSystems =
        fn: nixpkgs.lib.genAttrs supportedSystems (system: fn nixpkgs.legacyPackages.${system});

      mkHaskellPkgs =
        pkgs:
        pkgs.haskellPackages.extend (
          self: super: {
            site = self.callCabal2nix "site" (haskellSourceFilter ./.) { };
            pandoc-sidenote = self.callCabal2nixWithOptions "pandoc-sidenote" (builtins.fetchGit {
              url = "https://github.com/jez/pandoc-sidenote";
              rev = "3658e7da9453fb6ab817d8eef5d1928cbcd3afbf";
            }) "-f html-sidenotes" { };
          }
        );
    in
    {
      # nix build
      packages = forAllSystems (pkgs: {
        default = (mkHaskellPkgs pkgs).site;
      });
      # nix develop
      devShells = forAllSystems (pkgs: {
        default =
          let
            hPkgs = mkHaskellPkgs pkgs;
          in
          hPkgs.shellFor {
            packages = p: [ p.site ];
            nativeBuildInputs = [ hPkgs.haskell-language-server ];
            buildInputs = with pkgs; [
              deno # KaTeX rendering of maths—see scripts/math.ts
              (python3.withPackages (p: [
                p.fonttools # Compressing fonts
                p.brotli # Compressing fonts
                p.pygments # Syntax highlighting
              ]))
              zlib
            ];
          };
      });
    };
}
