{ lib
, fetchurl
, buildDunePackage, camlp5
, ocaml
, menhir, menhirLib
, atdgen
, stdlib-shims
, re, perl, ncurses
, ppxlib, ppx_deriving
, ppxlib_0_15, ppx_deriving_0_15
, version ? if lib.versionAtLeast ocaml.version "4.08" then "1.18.1"
    else "1.15.2"
}:

let p5 = camlp5; in
let camlp5 = p5.override { legacy = true; }; in

let tarball =
  if lib.versionAtLeast version "1.13.8"
  then "elpi-${version}.tbz"
  else "elpi-v${version}.tbz"
; in

buildDunePackage {
  pname = "elpi";
  inherit version;

  src = fetchurl {
    url = "https://github.com/LPCIC/elpi/releases/download/v${version}/${tarball}";
    hash = {
      "1.19.2" = "sha256-dBj5Ek7PWq/8Btq/dggJUqa8cUtfvbi6EWo/lJEDOU4=";
      "1.18.1" = "sha256-rrIv/mVC0Ez3nU7fpnzwduIC3tI6l73DjgAbv1gd2v0=";
      "1.17.0" = "sha256-J8FJBeaB+2HtHjrkgNzOZJngZ2AcYU+npL9Y1HNPnzo=";
      "1.15.2" = "sha256-+sQYQiN3n+dlzXzi5opOjhkJZqpkNwlHZcUjaUM6+xQ=";
      "1.15.0" = "sha256-vpQzbkDqJPCmaBmXcBnzlWGS7djW9wWv8xslkIlXgP0=";
      "1.13.7" = "sha256-0QbOEnrRCYA2mXDGRKe+QYCXSESLJvLzRW0Iq+/3P9Y=";
      "1.12.0" = "sha256-w4JzLZB8jcxw7nA7AfgU9jTZTr6IYUxPU5E2vNIFC4Q=";
      "1.11.4" = "sha256-dyzEpzokgffsF9lt+FZgUlcZEuAb70vGuHfGUtjZYIM=";
    }."${version}";
  };

  patches = lib.optional (version == "1.16.5")
    ./atd_2_10.patch;

  minimalOCamlVersion = "4.07";

  # atdgen is both a library and executable
  nativeBuildInputs = [ perl ]
  ++ [ (if lib.versionAtLeast version "1.15" || version == "dev" then menhir else camlp5) ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen;
  buildInputs = [ ncurses ]
  ++ lib.optional (lib.versionAtLeast version "1.16" || version == "dev") atdgen;

  propagatedBuildInputs = [ re stdlib-shims ]
  ++ (if lib.versionAtLeast version "1.15" || version == "dev"
     then [ menhirLib ]
     else [ camlp5 ]
  )
  ++ (if lib.versionAtLeast version "1.13" || version == "dev"
     then [ ppxlib ppx_deriving ]
     else [ ppxlib_0_15 ppx_deriving_0_15 ]
  );

  meta = with lib; {
    description = "Embeddable λProlog Interpreter";
    license = licenses.lgpl21Plus;
    maintainers = [ maintainers.vbgl ];
    homepage = "https://github.com/LPCIC/elpi";
  };

  postPatch = ''
    substituteInPlace elpi_REPL.ml --replace-warn "tput cols" "${ncurses}/bin/tput cols"
  '';
}
