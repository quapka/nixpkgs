{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  # package deps
  lxml,
  dict2xml,
  xmltodict,
  six,
  aenum,
  tblib,
  requests,
  generateds,
  # venvShellHook,
  # dev deps
  check-manifest,
  # test deps
  coverage,
  pytest,
  python
}:

buildPythonPackage rec {
  pname = "pyone";
  version = "6.9.80";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "OpenNebula";
    repo = "one";
    rev = "refs/tags/release-${version}";
    hash = "sha256-iJEWhZpvNTMlvv2lVn5DD2Ali+andrLQg/rPCttjbII=";
  };

  sourceRoot = "source/src/oca/python";

  # patchPhase = ''
  #   substituteInPlace pyone/__init__.py \
  #     --replace-fail 'from pyone import bindings' 'import pyone.bindings'
  # '';

  nativeBuildInputs = [
    generateds
  ];

  propagatedBuildInputs= [
    lxml
    dict2xml
    xmltodict
    six
    aenum
    tblib
    requests
  ];

  # NOTE: the tests directory/module does not exist
  #       see https://github.com/OpenNebula/one/issues/6685
  doCheck = false;

  bindingsDir = "${python.sitePackages}/${pname}/bindings";

  postInstall = ''
    mkdir --parents $out/${bindingsDir}
    ${generateds.bin}/generateDS.py -q -f -o $out/${bindingsDir}/supbind.py \
      -s $out/${bindingsDir}/__init__.py --super=supbind --external-encoding=utf-8 \
      --silence ../../../share/doc/xsd/index.xsd
    sed -i "s/import supbind/from . import supbind/" $out/${bindingsDir}/__init__.py
    sed -i "s/import sys/import sys\nfrom pyone.util import TemplatedType/" $out/${bindingsDir}/__init__.py
    sed -i "s/(supermod\./(TemplatedType, supermod\./g" $out/${bindingsDir}/__init__.py
    # sed -i "s/import supbind as supermod/from . import supbind as supermod/g" $out/${bindingsDir}/__init__.py
  '';


  # # # NOTE this is a very limited check see the note above
  # checkPhase = ''
  #   python -c 'import pyone'
  # '';

  # nativeCheckInputs = [
  #   coverage
  #   pytest
  # ];

  meta = with lib; {
    description = "";
    mainProgram = "";
    homepage = "https://github.com/${src.owner}/${src.repo}";
    license = licenses.asl20;
    maintainers = with maintainers; [ maintainers.quapka ];
  };
}
