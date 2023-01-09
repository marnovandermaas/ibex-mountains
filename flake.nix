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

    (flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = { allowUnfree = true; };
        };

        # Using requireFile prevents rehashing each time,
        # This saves much seconds during rebuilds.
        src = pkgs.requireFile rec {
          name = "vivado_bundled.tar.gz";
          sha256 = "1yxx6crvawhzvary9js0m8bzm35vv6pzfqdkv095r84lb13fyp7b";
          # Print the following message if the name / hash are not
          # found in the store.
          message = ''
            requireFile :
            file/dir not found in /nix/store
            file = ${name}
            hash = ${sha256}

            This nix expression requires that ${name} is already part of the store.
            - Login to xilinx.com
            - Download from https://www.xilinx.com/support/download.html,
            - Rename the file to ${name}
            - Add it to the nix store with
              $ nix-prefetch-url --type sha256 --print-path file:</path/to/${name}>
          '';
        };
        vivado = pkgs.callPackage (import ./vivado.nix) {
          vivado-src = pkgs.stdenv.mkDerivation rec {
            pname = "vivado_src";
            version = "2022.2";
            inherit src;
            postPatch = ''
              patchShebangs .
              patchelf \
                --set-interpreter $(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker) \
                tps/lnx64/jre*/bin/java
            '';
            dontBuild = true; dontFixup = true;
            installPhase = ''
              mkdir -p $out
              cp -R * $out
            '';
          };
        };
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
        packages.src1 = vivado;
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
