{ stdenv, lib, buildDunePackage, fetchurl, ocaml, ocaml-migrate-parsetree
, version ? "1.3"
}:

let param = {
      "1.3" = {
        sha256 = "1r4jp0516378js62ss50a9s8ql2pm8lfdd3mnk214hp7s0kb17fl";
      };
      "1.4" = {
        sha256 = "0wa9vcrc26kirc2cqqs6kmarbi8gqy3dgdfiv9y7nzsgy1liqacq";
        useDune2 = true;
      };
}; in

buildDunePackage (rec {

	pname = "ppxfind";
	inherit version;
  
	src = fetchurl {
		url = "https://github.com/diml/ppxfind/releases/download/${version}/ppxfind-${version}.tbz";
		inherit (param.${version}) sha256;
	};

	minimumOCamlVersion = "4.03";

	buildInputs = [ ocaml-migrate-parsetree ];


  # Don't run the native `strip' when cross-compiling.
  dontStrip = stdenv.hostPlatform != stdenv.buildPlatform;

	meta = {
		homepage = "https://github.com/diml/ppxfind";
		description = "ocamlfind ppx tool";
		license = lib.licenses.bsd3;
		maintainers = [ lib.maintainers.vbgl ];
  };
}
// (if param.${version}?useDune2 then {inherit (param.${version}) useDune2;} else {})
// (
if lib.versions.majorMinor ocaml.version == "4.04" then {
  dontStrip = true;
} else {}
))
