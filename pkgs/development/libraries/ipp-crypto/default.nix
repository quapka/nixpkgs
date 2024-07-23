{ lib
, gcc11Stdenv
, fetchgit
, cmake
, nasm
, python39
, ninja
, openssl
}:
gcc11Stdenv.mkDerivation (finalAttrs: rec {
  pname = "ipp-crypto";
  version = "2021.12.1";

  src = fetchgit {
    url = "https://github.com/intel/ipp-crypto";
    rev = "ippcp_${finalAttrs.version}";
    hash = "sha256-voxjx9Np/8jy9XS6EvUK4aW18/DGQGaPpTKm9RzuCU8=";
  };

  nativeBuildInputs = [ cmake nasm python39 openssl ninja ];

  buildDir = "_build";

  configurePhase = ''
    CC=gcc CXX=g++ cmake CMakeLists.txt -GNinja -B${buildDir} -DARCH=intel64 -DCMAKE_BUILD_TYPE=Release
  '';

  buildPhase = ''
    pushd ${buildDir}
    ninja
    popd
  '';

  checkPhase = ''
    cmakePcfileCheckPhase
  '';

  # NOTE: put .build/RELEASE/pkgconfig to $out/lib/?
  installPhase = ''
    mkdir --parents $out $dev

    mv ${buildDir}/.build/RELEASE/include $dev/include
    mv ${buildDir}/.build/RELEASE/* $out
  '';

  outputs = [ "out" "dev" ];

  meta = with lib; {
    description = "Intel® Integrated Performance Primitives Cryptography";
    homepage    = "https://github.com/intel/ipp-crypto";
    maintainers = [ maintainers.quapka ];
    license = with licenses; [ asl20 ];
  };
})
