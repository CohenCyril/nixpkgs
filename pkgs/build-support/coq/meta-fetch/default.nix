{
  lib,
  stdenv,
<<<<<<< HEAD
  fetchurl,
  fetchzip,
}@args:

let
  lib = import ../extra-lib.nix {
    inherit (args) lib;
  };

  inherit (lib)
    attrNames
    fakeSha256
    filter
    findFirst
    head
    isAttrs
    isPath
    isString
    last
    length
    optionalAttrs
    pathExists
    pred
    sort
    switch
    switch-if
    versionOlder
    versions
    ;

  inherit (lib.strings) match split;

=======
  fetchzip,
}@args:
let
  lib' = import ../extra-lib.nix { inherit lib; };
in
with builtins;
with lib';
let
>>>>>>> a62b21cf2519 (coqPackages: etc)
  default-fetcher =
    {
      domain ? "github.com",
      owner ? "",
      repo,
      rev,
      name ? "source",
      sha256 ? null,
<<<<<<< HEAD
      artifact ? null,
      ...
    }@args:
    let
      kind =
        switch-if
          [
            {
              cond = artifact != null;
              out = {
                ext = "tbz";
                fmt = "tbz";
                fetchfun = fetchurl;
              };
            }
            {
              cond = args ? sha256;
              out = {
                ext = "zip";
                fmt = "zip";
                fetchfun = fetchzip;
              };
            }
          ]
          {
            ext = "tar.gz";
            fmt = "tarball";
            fetchfun = builtins.fetchTarball;
          };
    in
    with kind;
    let
      pr = match "^#(.*)$" rev;
      url = switch-if [
        {
          cond = pr == null && (match "^github.*" domain) != null && artifact != null;
          out = "https://github.com/${owner}/${repo}/releases/download/${rev}/${artifact}";
        }
        {
          cond = pr == null && (match "^github.*" domain) != null;
          out = "https://${domain}/${owner}/${repo}/archive/${rev}.${ext}";
        }
        {
          cond = pr != null && (match "^github.*" domain) != null;
          out = "https://api.${domain}/repos/${owner}/${repo}/${fmt}/pull/${head pr}/head";
        }
        {
          cond = pr == null && (match "^gitlab.*" domain) != null;
          out = "https://${domain}/${owner}/${repo}/-/archive/${rev}/${repo}-${rev}.${ext}";
        }
        {
          cond = (match "(www.)?mpi-sws.org" domain) != null;
          out = "https://www.mpi-sws.org/~${owner}/${repo}/download/${repo}-${rev}.${ext}";
        }
      ] (throw "meta-fetch: no fetcher found for domain ${domain} on ${rev}");
      fetch = x: fetchfun (if args ? sha256 then (x // { inherit sha256; }) else x);
=======
      ...
    }@args:
    let
      ext = if args ? sha256 then "zip" else "tar.gz";
      fmt = if args ? sha256 then "zip" else "tarball";
      pr = match "^#(.*)$" rev;
      url = switch-if [
        {
          cond = isNull pr && !isNull (match "^github.*" domain);
          out = "https://${domain}/${owner}/${repo}/archive/${rev}.${ext}";
        }
        {
          cond = !isNull pr && !isNull (match "^github.*" domain);
          out = "https://api.${domain}/repos/${owner}/${repo}/${fmt}/pull/${head pr}/head";
        }
        {
          cond = isNull pr && !isNull (match "^gitlab.*" domain);
          out = "https://${domain}/${owner}/${repo}/-/archive/${rev}/${repo}-${rev}.${ext}";
        }
        {
          cond = !isNull (match "(www.)?mpi-sws.org" domain);
          out = "https://www.mpi-sws.org/~${owner}/${repo}/download/${repo}-${rev}.${ext}";
        }
      ] (throw "meta-fetch: no fetcher found for domain ${domain} on ${rev}");
      fetch = x: if args ? sha256 then fetchzip (x // { inherit sha256; }) else fetchTarball x;
>>>>>>> a62b21cf2519 (coqPackages: etc)
    in
    fetch { inherit url; };
in
{
  fetcher ? default-fetcher,
  location,
  release ? { },
  releaseRev ? (v: v),
<<<<<<< HEAD
  releaseArtifact ? (v: null),
=======
  combined ? false,
# set combined to true return a meta-fetcher which
# uses one of origin, version and defaultVersion
# origin is used first, else version and otherwise defaultVersion
>>>>>>> a62b21cf2519 (coqPackages: etc)
}:
let
  isVersion = x: isString x && match "^/.*" x == null && release ? ${x};
  shortVersion =
    x:
    if (isString x && match "^/.*" x == null) then
<<<<<<< HEAD
      findFirst (v: versions.majorMinor v == x) null (sort (l: r: versionOlder r l) (attrNames release))
=======
      findFirst (v: versions.majorMinor v == x) null (sort versionAtLeast (attrNames release))
>>>>>>> a62b21cf2519 (coqPackages: etc)
    else
      null;
  isShortVersion = x: shortVersion x != null;
  isPathString = x: isString x && match "^/.*" x != null && pathExists x;
<<<<<<< HEAD
in
arg:
switch arg [
  {
    case = isNull;
    out = {
      version = "broken";
      src = "";
      broken = true;
    };
  }
  {
    case = isPathString;
    out = {
      version = "dev";
      src = arg;
    };
  }
  {
    case = pred.union isVersion isShortVersion;
    out =
      let
        v = if isVersion arg then arg else shortVersion arg;
        given-sha256 = release.${v}.sha256 or "";
        sha256 = if given-sha256 == "" then fakeSha256 else given-sha256;
        rv = release.${v} // {
          inherit sha256;
        };
      in
      {
        version = rv.version or v;
        src =
          rv.src or (fetcher (
            location
            // {
              rev = releaseRev v;
              artifact = releaseArtifact v;
            }
            // rv
          ));
      };
  }
  {
    case = isString;
    out =
      let
        splitted = filter isString (split ":" arg);
        rev = last splitted;
        has-owner = length splitted > 1;
        version = "dev";
      in
      {
        inherit version;
        src = fetcher (
          location // { inherit rev; } // (optionalAttrs has-owner { owner = head splitted; })
        );
      };
  }
  {
    case = isAttrs;
    out = {
      version = arg.version or "dev";
      src = (arg.fetcher or fetcher) (location // (arg.location or { }));
    };
  }
  {
    case = isPath;
    out = {
      version = "dev";
      src = builtins.path {
        path = arg;
        name = location.name or "source";
      };
    };
  }
] (throw "not a valid source description")
=======
  unNull = value: default: if !isNull value then value else default;

  # it can be convenient to provide a combination of
  # origin, version and defaultVersion
  combine =
    {
      origin ? null,
      version ? null,
      defaultVersion ? null,
      pname ? "",
    }:
    let
      fetched = fetch (unNull origin (unNull version defaultVersion));
    in
    {
      inherit (fetched) src;
      version = switch-if [
        {
          cond = !isNull origin && !isNull version;
          out = version;
        }
        {
          cond = isNull origin && !isNull version;
          out =
            (
              if version == fetched.version || isNull version then
                (x: x)
              else
                warn (
                  optionalString (pname != "") "while building ${pname}"
                  + ''
                    using `version` without `origin` is deprecated except for releases,
                    please use `origin` instead of `version`.
                  ''
                )
            )
              fetched.version;
        }
      ] fetched.version;
    }
    // optionalAttrs (fetched.broken or false) { inherit (fetched) broken; };

  # main function, with only one argument
  fetch =
    origin:
    switch origin [
      {
        case = isNull;
        out = {
          version = "broken";
          src = "";
          broken = true;
        };
      }
      {
        case = isPathString;
        out = {
          version = "999";
          src = origin;
        };
      }
      {
        case = pred.union isVersion isShortVersion;
        out =
          let
            v = if isVersion origin then origin else shortVersion origin;
          in
          let
            given-sha256 = release.${v}.sha256 or "";
            sha256 = if given-sha256 == "" then lib.fakeSha256 else given-sha256;
            rv = release.${v} // {
              inherit sha256;
            };
          in
          {
            version = rv.version or v;
            src = rv.src or fetcher (location // { rev = releaseRev v; } // rv);
          };
      }
      {
        case = isString;
        out =
          let
            # syntax: "[owner[/repo]:]rev" where brackets denote optionals
            ownerRepo-rev = filter isString (split ":" origin);
            owner-repo = filter isString (split "/" (head ownerRepo-rev));
            rev = last ownerRepo-rev;
            has-ownerRepo = length ownerRepo-rev > 1;
            has-repo = has-ownerRepo && length owner-repo > 1;
            version = "999";
          in
          {
            inherit version;
            src = fetcher (
              location
              // {
                inherit rev;
              }
              // (optionalAttrs has-ownerRepo { owner = head owner-repo; })
              // (optionalAttrs has-repo { repo = last owner-repo; })
            );
          };
      }
      {
        case = isAttrs;
        out = let {
          version = origin.version or "999";
          src = (origin.fetcher or fetcher) (location // (origin.location or { }));
        };
      }
      {
        case = isPath;
        out = {
          version = "999";
          src = builtins.path {
            path = origin;
            name = location.name or "source";
          };
        };
      }
    ] (throw "not a valid source description");
in
if combined then combine else fetch
>>>>>>> a62b21cf2519 (coqPackages: etc)
