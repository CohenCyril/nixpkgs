{ stdenv, fetchFromGitHub, coq }:

let params =
  {
    "8.7" = {
      version = "1.1.2+coq8.7";
      sha256 = "09n0ky7ldb24by7yf5j3hv410h85x50ksilf7qacl7xglj4gy5hj";
    };
    "8.8" = {
      version = "1.1.2+coq8.8";
      sha256 = "0rc4lshqvnfdsph98gnscvpmlirs9wx91qcvffggg73xw0p1g9s0";
    };
    "8.9" = {
      version = "1.1.2+coq8.9";
      sha256 = "1jjzgpff09xjn9kgp7w69r096jkj0x2ksng3pawrmhmn7clwivbk";
    };
    "8.10" = {
      version = "1.1.2+coq8.10";
      sha256 = "1lq1mw15w4yky79qg3rm0mpzqi2ir51b6ak04ismrdr7ixky49y8";
    };
  };
  param = params.${coq.coq-version};
in

stdenv.mkDerivation rec {
  inherit (param) version;
  name = "coq${coq.coq-version}-paramcoq-${version}";
  src = fetchFromGitHub {
    owner = "coq-community";
    repo = "paramcoq";
    rev = "v${version}";
    inherit (param) sha256;
  };

  buildInputs = [ coq ]
  ++ (with coq.ocamlPackages; [ ocaml findlib camlp5 ])
  ;

  installFlags = [ "COQLIB=$(out)/lib/coq/${coq.coq-version}/" ];

  passthru = {
    compatibleCoqVersions = v: builtins.hasAttr v params;
  };

  meta = {
    description = "Coq plugin for parametricity";
    inherit (src.meta) homepage;
    license = stdenv.lib.licenses.mit;
    maintainers = [ stdenv.lib.maintainers.vbgl ];
    inherit (coq.meta) platforms;
  };
}
