{ stdenvNoCC, fetchFromGitHub, ... }:
stdenvNoCC.mkDerivation {
  pname = "tieba-cloud-sign";
  version = "5.02-unstable-2025-03-11";

  src = fetchFromGitHub {
    owner = "MoeNetwork";
    repo = "Tieba-Cloud-Sign";
    rev = "ab8f83e61aaf87dec82ad8c5e540d0c91933a8da";
    hash = "sha256-cs8PTo02Xewyq3QAdvOIP3wvn2oOC1HM4u0ZDzKpDoQ=";
  };

  buildPhase = ''
    mkdir $out
    cp -r $src/* $out
  '';
}
