{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "libecc";
  version = "1.1.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aldenml";
    repo = "ecc";
    rev = "v${version}";
    hash = "sha256-g55ao7YdJXpn38nGm15l6YStI4simwgJqA7Lsp92E7c=";
  };

  nativeBuildInputs = [ ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/aldenml/ecc";
    description = "Library to work with elliptic-curve cryptography based on libsodium and blst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
