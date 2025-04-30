{
  stdenv,
  fetchFromGitHub,

  automake,
  autoconf,
  libtool,
  pkg-config,
  help2man,
  pcsclite,
  python3,
}:
stdenv.mkDerivation rec {
  pname = "vsmartcard";
  name = pname;
  vesion = "0.10";

  src = fetchFromGitHub {
    owner = "frankmorgner";
    repo = "vsmartcard";
    rev = "virtualsmartcard-0.10";
    hash = "sha256-+BrX2aqByUvIUbN4K+sdq9bH29FD2rtTt4q+URPgx7A=";
  };

    srcDirectory = "./virtualsmartcard/";

    configurePhase = ''
      pushd ${srcDirectory}
      autoreconf -vis
      ./configure --prefix $out
      popd
    '';

    installPhase = ''
      pushd ${srcDirectory}
      make install
      popd
    '';

    nativeBuildInputs = [
        automake
        autoconf
        libtool
        help2man
        pkg-config
        pcsclite
        python3
    ];
}
