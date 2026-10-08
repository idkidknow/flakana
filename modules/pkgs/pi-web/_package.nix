{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  jq,
  nodejs_24,
  noto-fonts,
}:

buildNpmPackage {
  pname = "pi-web";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "v0.10.0";
    hash = "sha256-dDE+m6ZpiC4N2xWNMvhRshCjqFU5gr2+t7RpvC9dNUk=";
  };

  npmDepsHash = "sha256-sf7NMgLx1cELzHl7ycCuZKg32H1J2qCL6+GsxTqPmjs=";
  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  nodejs = nodejs_24;

  # Reuse integrity hashes from entries with the same tarball URL. Upstream
  # omits them from some nested pi packages. Supplement packages that only
  # appear without integrity using their npm registry hashes. Drop dependencies
  # bundled in the optional Tailwind wasm tarball, which have no resolved URL.
  postPatch = ''
    ${lib.getExe jq} '
      (.packages | [.[] | select(.resolved and .integrity)]
        | map({key: .resolved, value: .integrity}) | from_entries)
        + {
          "https://registry.npmjs.org/@earendil-works/chord/-/chord-1.0.0.tgz": "sha512-BIfWfrByM0pKq6tfKYXuwx0ed2CvaqIM3EDA7Dps+fP+d3CiPWdlHi1cDsJC05llqKJoRz5//G0hz0yQwwjISQ==",
          "https://registry.npmjs.org/@earendil-works/pi-codemode/-/pi-codemode-1.0.0.tgz": "sha512-LPpFI4+T9NzDnhBDs15izWAolaoM8xnwqdziRd6Zx8BQeoEPvzefD2vMMzSyF0rOtq34TfQqkZ0ki16f6cGdMg==",
          "https://registry.npmjs.org/@earendil-works/pi-mcp/-/pi-mcp-1.0.0.tgz": "sha512-rYra0aF5iPmJd+fsB+VBuqxWNABGJ3Iiyhg0CqIc/91ta2n7IvQmCp0Cac/YkUTNnvRsVZnjgAiBkRi6+ouWuw=="
        } as $integrities
      | .packages |= with_entries(
          select(.key | startswith("node_modules/@tailwindcss/oxide-wasm32-wasi/node_modules/") | not)
          | if .value.resolved and (.value.integrity | not) then
              .value.integrity = ($integrities[.value.resolved] // error("Missing integrity for " + .key))
            else . end
        )
    ' package-lock.json > package-lock.json.tmp
    mv package-lock.json.tmp package-lock.json
  '';

  # npm 11 crashes while pruning the reconstructed nested pi dependency tree.
  # Let prune use npm ci's hidden lockfile, refreshed after shebang patching.
  preInstall = ''
    unset NIX_NODEJS_BUILDNPMPACKAGE
    touch node_modules/.package-lock.json
  '';

  preBuild = ''
    cp ${noto-fonts}/share/fonts/noto/NotoSansMono.ttf app/NotoSansMono.ttf
    substituteInPlace app/layout.tsx \
    --replace-fail \
      'import { Noto_Sans_Mono } from "next/font/google";' \
      'import localFont from "next/font/local";' \
    --replace-fail \
      'const notoSansMono = Noto_Sans_Mono({' \
      'const notoSansMono = localFont({' \
    --replace-fail \
      '  subsets: ["latin", "cyrillic"],' \
      '  src: "./NotoSansMono.ttf",'
  '';

  meta = {
    description = "Web UI for the pi coding agent";
    homepage = "https://github.com/agegr/pi-web";
    license = lib.licenses.mit;
    mainProgram = "pi-web";
    platforms = lib.platforms.unix;
  };
}
