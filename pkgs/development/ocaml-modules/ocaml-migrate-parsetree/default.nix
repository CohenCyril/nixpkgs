{ lib, fetchFromGitHub, buildDunePackage, result, ppx_derivers
, version ? "1.5.0"
}:

let param = {
      "1.5.0" = {
        sha256 = "0ms7nx7x16nkbm9rln3sycbzg6ad8swz8jw6bjndrill8bg3fipv";
      };
      "1.7.3" = {
        sha256 = "0336vz0galjnsazbmkxjwdv1qvdqsx2rgrvp778xgq2fzasz45cx";
      };
}; in
buildDunePackage rec {
   pname = "ocaml-migrate-parsetree";
   inherit version;

   src = fetchFromGitHub {
     owner = "ocaml-ppx";
     repo = pname;
     rev = "v${version}";
     inherit (param.${version}) sha256;
   };

   propagatedBuildInputs = [ ppx_derivers result ];

   meta = {
     description = "Convert OCaml parsetrees between different major versions";
     license = lib.licenses.lgpl21;
     maintainers = [ lib.maintainers.vbgl ];
     inherit (src.meta) homepage;
   };
}
