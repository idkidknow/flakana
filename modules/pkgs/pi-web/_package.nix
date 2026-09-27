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
  version = "0.9.3";

  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "v0.9.3";
    hash = "sha256-EhoxOwmEIsN3G6MQImZbCSJM4QBnnzKzNV+gmuIUkN0=";
  };

  npmDepsHash = "sha256-ioz3ploxZo+2vsVHAbcxw3T/LkpXIwaBjfEib8fgeSY=";
  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  nodejs = nodejs_24;

  # Reuse integrity hashes from entries with the same tarball URL. Upstream
  # omits them from some nested pi packages. Drop dependencies bundled in the
  # optional Tailwind wasm tarball, which have no resolved URL of their own.
  postPatch = ''
    ${lib.getExe jq} '
      (.packages | [.[] | select(.resolved and .integrity)]
        | map({key: .resolved, value: .integrity}) | from_entries) as $integrities
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
