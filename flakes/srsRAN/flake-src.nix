{
  description = "srsRAN Project with googletest as a dependency";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable"; # or a specific commit
    flake-utils.url = "github:numtide/flake-utils"; # for utility functions
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system: let
    pkgs = import nixpkgs { inherit system; };

    # Define googletest as a separate derivation
    googletest = pkgs.stdenv.mkDerivation {
      pname = "googletest";
      version = "1.12.1";

      src = pkgs.fetchFromGitHub {
        owner = "google";
        repo = "googletest";
        rev = "release-1.12.1";
        sha256 = "1cv55x3amwrvfan9pr8dfnicwr8r6ar3yf6cg9v6nykd6m2v3qsv";
      };

      nativeBuildInputs = [ pkgs.cmake pkgs.python3 ];

      buildPhase = ''
        cmake ..
        make
      '';

      installPhase = ''
        make install
      '';

      meta = {
        description = "Google's C++ test framework";
        homepage = "https://github.com/google/googletest";
        license = pkgs.lib.licenses.bsd3;
        platforms = pkgs.lib.platforms.all;
      };
    };

    # Define the main project derivation
    main = pkgs.stdenv.mkDerivation rec {
      pname = "srsRAN-Project";
      version = "24_04";

      src = [ ./. ];

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.pkg-config
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
        googletest  # Now we are using googletest as a dependency
      ];

      configurePhase = ''
        mkdir -p build
        cd build
        cmake .. -Wno-dev -Wfatal-errors -DBUILD_TESTS=OFF -DCMAKE_C_FLAGS="-m64 -march=native" -DCMAKE_CXX_FLAGS="-m64 -march=native" -DCMAKE_SYSTEM_PROCESSOR=x86_64
      '';

      buildPhase = ''
				echo "Building for architecture: $(uname -m)"
        make -j20 VERBOSE=1
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

