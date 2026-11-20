{
  description = "STE80 Humanizer agent skill (Dodaios/ste80-humanizer), pinned to default-branch HEAD.";

  inputs = {
    flake-lib = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:jgus-org/flake-lib/v1";
    };
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    {
      self,
      flake-lib,
      nixpkgs,
    }:
    let
      pin = import ./pin.nix;

      source = {
        owner = "Dodaios";
        repo = "ste80-humanizer";
        track = "commit";
        type = "github";
      };
    in
    {
      skill = builtins.fetchTarball {
        sha256 = pin.sourceHash;
        url = "https://github.com/${source.owner}/${source.repo}/archive/${pin.sourceRev}.tar.gz";
      };
    }
    // flake-lib.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
        orgFormatting = flake-lib.lib.mkFormatting {
          inherit self system;
        };
      in
      {
        checks.formatting = orgFormatting.check;
        formatter = orgFormatting.formatter;
        packages.update-version = flake-lib.lib.mkUpdateVersion {
          inherit pkgs source;
        };
      }
    );
}
