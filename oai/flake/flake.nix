{
  description = "OpenAirInterface as a flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or a specific commit
    flake-utils.url = "github:numtide/flake-utils"; # for utility functions
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };

    # Define googletest as a separate derivation
    asn1c = pkgs.stdenv.mkDerivation {
        pname = "asn1c";
        version = "1.12.1";


        src = pkgs.fetchFromGitHub {
         owner = "mouse07410";
         repo = "asn1c";
         rev = "940dd5fa9f3917913fd487b13dfddfacd0ded06e";
         sha256 = "p9MAkwzeAL3I3PL0o15ABMluoorU1gcJbmU+s9DgPiY=";
    };

    nativeBuildInputs = [ pkgs.perl pkgs.autoconf pkgs.automake pkgs.libtool pkgs.bison pkgs.flex];


    preConfigure = ''
        patchShebangs examples/crfc2asn1.pl
        '';



    buildPhase = ''
        if [ ! -f configure ]; then
            autoreconf -iv
        fi
            chmod +x examples/crfc2asn1.pl # Ensure it's executable
            ./configure --prefix=$out
    '';

    installPhase = ''
        make
        make install
        '';

    meta = with pkgs.lib; {
        homepage = "http://lionet.info/asn1c/compiler.html";
        description = "Open Source ASN.1 Compiler";
        license = licenses.bsd2;
        platforms = platforms.unix;
        maintainers = [ maintainers.numinit ];
    };

    };

    simde = pkgs.stdenv.mkDerivation {
        pname = "simde";
        version = "mod";


        src = pkgs.fetchFromGitHub {
         owner = "simd-everywhere";
         repo = "simde-no-tests";
         rev = "1a09d3bc9de47c4d9a5daa23eb753d5322748201";
         sha256 = "lZ37lVRN1SxkS9b04aj9UNZaRNuDUDIY+qOMAHu//9Y=";
    };
        installPhase = ''
            mkdir -p $out/include/simde
            cp -r * $out/include/simde
            '';

    meta = with pkgs.lib; {
        homepage = "http://lionet.info/asn1c/compiler.html";
        description = "Open Source ASN.1 Compiler";
        license = licenses.bsd2;
        platforms = platforms.unix;
        maintainers = [ maintainers.numinit ];
    };

    };

    # Define the main project derivation
    main = pkgs.stdenv.mkDerivation rec {
      pname = "OpenAirInterface";
      version = "2.0.0";

      src = [ ./. ];

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.pkg-config
        pkgs.openssl
        pkgs.blas
        pkgs.git
        pkgs.simde
        simde
        pkgs.xxd
        pkgs.zlib
        asn1c
      ];

      buildInputs = [
        pkgs.fftwFloat
        pkgs.mbedtls
        pkgs.boost
        pkgs.libconfig
        pkgs.lksctp-tools
        pkgs.pcsclite
        pkgs.uhd
        pkgs.soapysdr-with-plugins
        pkgs.libbladeRF
        pkgs.zeromq
        pkgs.yaml-cpp
        pkgs.libbfd
        pkgs.libdwg
        pkgs.libdwarf
        pkgs.doxygen
        pkgs.ninja
        pkgs.openssl
        pkgs.lapack
        asn1c
        pkgs.ncurses5
        pkgs.cpm-cmake
      ];

      preConfigure = ''
          '';
    
#${pkgs.hostPlatform.system}
    CFLAGS = "-march=x86-64-v3";
#-mtune=native -m64 -march=x86-64-v3 
			/*ideally cmake should autodetect the cpu architecture but, at the moment this is not working*/
#nr-uesoftmodem nr-cuup params_libconfig coding ldpc


             #cmake .. -DASN1C_EXEC=${asn1c}/bin/asn1c -DSIMDE_DIR=${simde}/include/simde -DCMAKE_C_FLAGS="-m64 -march=native -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NO_NATIVE=1" -DCMAKE_CXX_FLAGS="-m64 -march=native -DSIMDE_ENABLE_NATIVE_ALIASES -DSIMDE_NO_NATIVE=1" -DCMAKE_SYSTEM_PROCESSOR=x86_64 -GNinja && ninja nr-softmodem 
# -DSIMDE_DIR=${simde}/include/simde 
      configurePhase = ''
         mkdir -p build
         cd build

        gcc -march=native -dM -E - </dev/null > te 
        cat te
             cmake .. -DASN1C_EXEC=${asn1c}/bin/asn1c -DCMAKE_C_FLAGS=$CFLAGS -DCMAKE_CXX_FLAGS=$CFLAGS -GNinja && ninja nr-softmodem 
      '';

      buildPhase = ''
        make -j20
      '';

      installPhase = ''
        mkdir -p $out/bin
        mkdir -p $out/lib
        cp -r * $out/bin
      '';

      meta = {
        description = "Open source O-RAN 5G CU/DU solution from Software Radio Systems (SRS)";
        homepage = "https://github.com/srsran/srsRAN_Project";
        changelog = "https://github.com/srsran/srsRAN_Project/blob/${version}/CHANGELOG";
        license = pkgs.lib.licenses.agpl3Only;
        maintainers = with pkgs.lib.maintainers; [];
        platforms = pkgs.lib.platforms.all;
      };
    };
  in {
    packages.default = main;
    defaultPackage = main;
  });
}

