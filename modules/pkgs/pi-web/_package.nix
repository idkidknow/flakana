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
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "v0.15.0";
    hash = "sha256-EUa1w0HP5J45yNRGYLtP401q+mjyRjcq9FWhy+++wxk=";
  };

  npmDepsHash = "sha256-sYgOArpkPGEhmgpztxG+FuHOJSWbX12fXI5TXcd6WRg=";
  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  nodejs = nodejs_24;

  # Drop dependencies bundled in the optional Tailwind wasm tarball, which
  # have no resolved URL of their own.
  postPatch = ''
    ${lib.getExe jq} '
      .packages |= with_entries(
          select(.key | startswith("node_modules/@tailwindcss/oxide-wasm32-wasi/node_modules/") | not)
        )
    ' package-lock.json > package-lock.json.tmp
    mv package-lock.json.tmp package-lock.json
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
