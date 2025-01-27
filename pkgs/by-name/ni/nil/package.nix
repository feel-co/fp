{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "nil";
  version = "2024-08-06-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "oxalica";
    repo = "nil";
    rev = "577d160da311cc7f5042038456a0713e9863d09e";
    hash = "sha256-ggXU3RHv6NgWw+vc+HO4/9n0GPufhTIUjVuLci8Za8c=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-uZsLlFU9GKLvFllF7Kf5Q7HfN26KQojf4rvOb9p7Rjs=";

  nativeBuildInputs = [ nix ];

  env.CFG_RELEASE = version;

  # might be related to https://github.com/NixOS/nix/issues/5884
  preBuild = ''
    export NIX_STATE_DIR=$(mktemp -d)
  '';

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Yet another language server for Nix";
    homepage = "https://github.com/oxalica/nil";
    changelog = "https://github.com/oxalica/nil/releases/tag/${version}";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      figsoda
      oxalica
    ];
    mainProgram = "nil";
  };
}
