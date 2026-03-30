{
  description = "Nix flake for alias-free-torch (upstream: junjun3518/alias-free-torch)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; config.allowUnfree = true; };
    in {
      packages.${system}.default = pkgs.python3Packages.buildPythonPackage {
        pname = "alias-free-torch";
        version = "setup.py:0.0.6";
        pyproject = true;
        src = ./.;
        build-system = [ pkgs.python3Packages.setuptools ];
        dependencies = with pkgs.python3Packages; [ torch ];
        pythonRelaxDeps = true;
        doCheck = false;
      };

      devShells.${system}.default = pkgs.mkShell {
        buildInputs = [ (pkgs.python3.withPackages (ps: with ps; [ torch ])) ];
      };
    };
}
