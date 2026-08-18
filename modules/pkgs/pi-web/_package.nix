{
  buildNpmPackage,
  fetchFromGitHub,
  lib,
  nodejs_24,
  noto-fonts,
}:

buildNpmPackage {
  pname = "pi-web";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "agegr";
    repo = "pi-web";
    rev = "2a6e53710f6409e0cceb3de839a62f8cdf3ca3ca";
    hash = "sha256-WcWxsqywG29G+o5/Kth2B/P+BQuGbRLUaG2Q5qrCHrE=";
  };

  npmDepsHash = "sha256-zws063zZjZRVPhV/ug2ZTNda/OwQ+RxnkZCtD1MJ7Vo=";
  npmDepsFetcherVersion = 2;
  npmFlags = [ "--legacy-peer-deps" ];
  nodejs = nodejs_24;

  # Fill integrity hashes omitted from nested pi packages, then remove entries
  # bundled into the optional wasm32 Tailwind tarball. prefetch-npm-deps cannot
  # handle registry dependencies without an integrity hash.
  postPatch = ''
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-agent-core": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-agent-core/-/pi-agent-core-0.84.2.tgz",|&\n      "integrity": "sha512-8Pn3wSCxj0cfo5I6jxQYVB/3uuQRmHhAlEclyjqpOuMEdQMIODHizRogv56FLdbU+dTiGnybeHQ2N+sV1/L2YA==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-ai": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-ai/-/pi-ai-0.84.2.tgz",|&\n      "integrity": "sha512-6MzsrYIYNVlE7SfpbL2yYb67Qo58p/7Q+xWG1RZvoX1P80aRCHSod2/13aFpxkow1lPO2LEh3c495J0Gwmyjig==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-client": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-client/-/pi-client-0.84.2.tgz",|&\n      "integrity": "sha512-/RFSPhD/bZbpOp1oJj+UneSUFSgZhWxzcSENUY+8+8xhoBrWXMYI2t77XNx4Yf+c8YK2qTHquForhNcelYpXvg==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-protocol": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-protocol/-/pi-protocol-0.84.2.tgz",|&\n      "integrity": "sha512-jbBh03fkeckWEroHpcZBr4w5/Ibat8WwdXFlXHivYQImrQNFtLpDeL0t1cku4hmK0q3pceIRQHkw4fwbM4YILQ==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-telemetry": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-telemetry/-/pi-telemetry-0.84.2.tgz",|&\n      "integrity": "sha512-wg5caea7uIv1BHRBm2Y116RvFG4oSAiP5qk9tA2463PDGIr4K8M1Ceyyg5DOpF/shUUl0gk826yQJAeAcHYB9g==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@earendil-works\/pi-coding-agent\/node_modules\/@earendil-works\/pi-tui": {/,/^    },$/ s|      "resolved": "https://registry.npmjs.org/@earendil-works/pi-tui/-/pi-tui-0.84.2.tgz",|&\n      "integrity": "sha512-ds2TLihOnM5sLJB3VpXV6y0uR5efVuHf4MN7yDpsty6hA2DUO/EDVzjp/0od0G2JslzVLMjT8T8zavtxVb+qbg==",|' \
      package-lock.json
    sed -i \
      '/"node_modules\/@tailwindcss\/oxide-wasm32-wasi\/node_modules\/@emnapi\/core": {/,/"node_modules\/@tailwindcss\/oxide-win32-arm64-msvc": {/ {
        /"node_modules\/@tailwindcss\/oxide-win32-arm64-msvc": {/!d
      }' \
      package-lock.json
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
