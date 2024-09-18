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
      version = "v1.0.0";

      src = pkgs.fetchFromGitHub {
        owner = "mouse07410";
        repo = "asn1c";
        rev = "v1.0.0";
        sha256 = "viOsU3lpGTIJuBLah1IjE6RMqyJha/PeP/lwlOWE1k8=";
      };

			
			nativeBuildInputs = [ pkgs.perl pkgs.autoconf pkgs.automake pkgs.libtool pkgs.bison pkgs.flex];
			configurePhase = ''
				patchShebangs examples/crfc2asn1.pl
				test -f configure || autoreconf -iv
				sh configure
			'';

			buildPhase = ''
				make
			'';

			installPhase = ''
				mkdir -p $out/asn1c
				mkdir -p $out/libs
				cp -r asn1c $out/asn1c
				cp -r * $out/libs

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
        asn1c  # Now we are using googletest as a dependency
      ];

			/*ideally cmake should autodetect the cpu architecture but, at the moment this is not working*/
      configurePhase = ''
				asn1c -v 
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

