{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rhai";
  version = "1.24.0-unstable-2026-04-15";

  src = fetchFromGitHub {
    owner = "rhaiscript";
    repo = "rhai";
    rev = "c3202b62de1f37a410c1eb6c92420b6e6bff9a5c";
    hash = "sha256-d07F55uxFfsMIP6WpF7w2s89pUbsq2+uGMVckJk3OEA=";
    postFetch = ''
      cp $out/Cargo{.msrv,}.lock
    '';
  };

  cargoHash = "sha256-/Ufow2aoODa4UUBJN3epB+Gz5DmSq7oevoK02MACujM=";

  meta = {
    description = "Rhai - An embedded scripting language for Rust";
    homepage = "https://github.com/rhaiscript/rhai";
    changelog = "https://github.com/rhaiscript/rhai/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "rhai";
  };
})
