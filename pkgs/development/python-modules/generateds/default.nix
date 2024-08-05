{
  lib,
  buildPythonPackage,
  fetchurl,
  python,
  requests,
  lxml,
  six,
  pytestCheckHook,
}:
buildPythonPackage rec {
  pname = "generateds";
  version = "2.44.1";
  format = "setuptools";

  src = fetchurl {
    url = "mirror://sourceforge/generateds/${pname}-${version}.tar.gz";
    hash = "sha256-sM5VBDBxSx1DuajGjc/OCu+kZWvC4ch1YT4Jh7plJQs=";
  };

  nativeBuildInputs = [
    lxml
  ];

  propagatedBuildInputs = [
    requests
    six
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  patches = [
    ./fix-print-with-2to3.patch
  ];

  # # NOTE: While there
  # patchPhase = ''
  #   2to3 --no-diffs --nobackups --write **/*.py || true
  # '';

  doCheck = false;

  postInstall = ''
    mkdir --parents $bin $lib
    cp $out/bin/* $bin/
  '';

  outputs = [ "out" "bin" ];

  # checkPhase = ''
  #   python -m pytest tests/
  # '';

  # passthru.tests = {
  #   version = testers.testVersion { package = tox; };
  # };

  meta = with lib; {
    # description = "Generic virtualenv management and test command line tool";
    # mainProgram = "tox";
    # homepage = "https://github.com/tox-dev/tox";
    # license = licenses.mit;
    maintainers = [ ];
  };
}
