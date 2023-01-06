{ stdenv, lib, breakpointHook, requireFile
, fetchurl, patchelf, makeWrapper
, coreutils
, procps
, zlib
, ncurses5
, libuuid
, libSM
, libICE
, libX11
, libXrender
, libxcb
, libXext
, libXtst
, libXi
, glib
, gtk2
, freetype
}:

stdenv.mkDerivation rec {
  pname = "vivado";
  version = "2022.2";

  # requireFile prevents rehashing each time, which saves time during rebuilds.
  src = requireFile rec {
    name = "xilinx_bundle";
  #   message = ''
  #     This nix expression requires that ${name} is already part of the store.
  #     Login to Xilinx, download from
  #     https://www.xilinx.com/support/download.html,
  #     rename the file to ${name}, and add it to the nix store with
  #     "nix-prefetch-url file:///path/to/${name}".
  #   '';
    message = ''
      New message.
    '';
    sha256 = "070hf2l0h31gi0vy4hfm655ina59hi05q2nxrhhgsi044v6hbifc";
  };

  nativeBuildInputs = [
    makeWrapper
    breakpointHook
  ];

  buildInputs = [
    procps
    ncurses5
  ];

  unpackPhase = ''
    local PREFIX=.
    mkdir -p $PREFIX
    ${src} --keep --noexec --target .
    cat xsetup
    exit 0
  '';

  postPatch = ''
    echo $(pwd)
    patchShebangs .

    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
             tps/lnx64/jre*/bin/java

    sed -i -- 's|/bin/rm|rm|g' xsetup
  '';

  dontBuild = true;

  installPhase = ''

    cat <<EOF > install_config.txt
    Edition=Vitis Unified Software Platform
    Destination=$out/opt
    Modules=Spartan-7:1,Virtex-7:1,Artix-7:1
    InstallOptions=Acquire or Manage a License Key:0,Enable WebTalk for SDK to send usage statistics to Xilinx:0
    CreateProgramGroupShortcuts=0
    ProgramGroupFolder=Xilinx Design Tools
    CreateShortcutsForAllUsers=0
    CreateDesktopShortcuts=0
    CreateFileAssociation=0
    EOF

    mkdir -p $out/opt
    export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${libPath}"
    export HOME=$out/userhome

    # The installer will be killed as soon as it says that post install tasks have failed.
    # This is required because it tries to run the unpatched scripts to check if the installation
    # has succeeded. However, these scripts will fail because they have not been patched yet,
    # and the installer will proceed to delete the installation if not killed.
    # set -x
    (./xsetup --agree XilinxEULA,3rdPartyEULA --batch Install --config install_config.txt || true) | while read line
    do
        [[ "''${line}" == *"Execution of Pre/Post Installation Tasks Failed"* ]] && echo "killing installer!" && ((pkill -9 -f "tps/lnx64/jre/bin/java") || true)
        echo ''${line}
    done
  '';

  libPath = lib.makeLibraryPath [
    stdenv.cc.cc
    ncurses5
    zlib
    libuuid
    libSM
    libICE
    libX11
    libXrender
    libxcb
    libXext
    libXtst
    libXi
    glib
    freetype
    gtk2
  ];

  preFixup = ''
    # Patch installed files
    patchShebangs $out/opt/Vivado/$version/bin
    patchShebangs $out/opt/SDK/$version/bin

    # Hack around lack of libtinfo in NixOS
    ln -s $ncurses/lib/libncursesw.so.6 $out/opt/Vivado/$version/lib/lnx64.o/libtinfo.so.5
    ln -s $ncurses/lib/libncursesw.so.6 $out/opt/SDK/$version/lib/lnx64.o/libtinfo.so.5

    # Patch ELFs
    for f in $out/opt/Vivado/$version/bin/unwrapped/lnx64.o/*
    do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || true
    done
    for f in $out/opt/SDK/$version/bin/unwrapped/lnx64.o/*
    do
        patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $f || true
    done
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/SDK/$version/eclipse/lnx64.o/eclipse
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $out/opt/SDK/$version/tps/lnx64/jre/bin/java

    wrapProgram $out/opt/Vivado/$version/bin/vivado --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/bin/xsdk --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/eclipse/lnx64.o/eclipse --prefix LD_LIBRARY_PATH : "$libPath"
    wrapProgram $out/opt/SDK/$version/tps/lnx64/jre/bin/java --prefix LD_LIBRARY_PATH : "$libPath"

    # wrapProgram on its own will not work because of the way the Vivado script runs ./launch
    # Therefore, we need Even More Patches...
    sed -i -- 's|`basename "\$0"`|vivado|g' $out/opt/Vivado/$version/bin/.vivado-wrapped
    sed -i -- 's|`basename "\$0"`|xsdk|g' $out/opt/SDK/$version/bin/.xsdk-wrapped

    # Add vivado and xsdk to bin folder
    mkdir $out/bin
    ln -s $out/opt/Vivado/$version/bin/vivado $out/bin/vivado
    ln -s $out/opt/SDK/$version/bin/xsdk $out/bin/xsdk
  '';

  meta = with lib; {
    description = "Xilinx Vivado";
    homepage = "https://www.xilinx.com/products/design-tools/vivado.html";
    license = licenses.unfree;
    maintainers = with maintainers; [ matthuszagh ];
  };
}
