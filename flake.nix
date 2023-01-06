{
  description = "A template that shows all standard flake outputs";

  # Inputs
  # https://nixos.org/manual/nix/unstable/command-ref/new-cli/nix3-flake.html#flake-inputs

  # The flake in the current directory.
  # inputs.currentDir.url = ".";

  # A flake in some other directory.
  # inputs.otherDir.url = "/home/alice/src/patchelf";

  # A flake in some absolute path
  # inputs.otherDir.url = "path:/home/alice/src/patchelf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = all@{ self, nixpkgs, flake-utils, ... }:

    # Utilized by `nix build .`
    # Utilized by `nix build`
    # defaultPackage.x86_64-linux = c-hello.defaultPackage.x86_64-linux;
    # packages.x86_64-linux.hello = c-hello.packages.x86_64-linux.hello;

    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };
        vivado = pkgs.callPackage (import ./vivado.nix) { };
      in {
        packages.dockertest = pkgs.dockerTools.buildImage {
          name = "hello-docker";
          copyToRoot = pkgs.buildEnv {
            name = "image-root";
            paths = [ pkgs.coreutils
                      pkgs.sl ];
          };
          config = {
            Cmd = [ "${pkgs.sl}/bin/sl" ];
          };
        };
        devShells.vivadotest = pkgs.mkShell {
          buildInputs = [
            vivado
          ];
        };
      })
    ) // {

      overlay = final: prev: { };
      overlays = { exampleOverlay = self.overlay; };

    # Utilized by `nix run .#<name>`
    # apps.x86_64-linux.hello = {
    #   type = "app";
    #   program = c-hello.packages.x86_64-linux.hello;
    # };

    # Utilized by `nix run . -- <args?>`
    # defaultApp.x86_64-linux = self.apps.x86_64-linux.hello;

    # Default overlay, for use in dependent flakes
    # Same idea as overlay but a list or attrset of them.
    # overlay = final: prev: { };
    # overlays = { exampleOverlay = self.overlay; };

    # Utilized by `nix develop`
    # Utilized by `nix develop .#<name>`
    # devShell.x86_64-linux = rust-web-server.devShell.x86_64-linux;
    # devShells.x86_64-linux.example = self.devShell.x86_64-linux;
  };
}
