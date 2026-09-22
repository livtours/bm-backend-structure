{ pkgs, lib, config, inputs, ... }:
let
  # needs to match Stackage LTS version from stack.yaml snapshot
  ghc = "ghc910";
  hsPkgs = pkgsUnstable.haskell.packages.${ghc};

  pkgsUnstable =
    import inputs.nixpkgs-unstable { system = pkgs.stdenv.system; };

  # Overridable environment variable (e.g. in .env)
  overridable = lib.mkOverride 2000;

  gitGui = pkgs.git.override { guiSupport = true; };
in {
  dotenv.enable = true; # .env
  dotenv.disableHint = true; # .env

  env.GHC_OPTIONS = overridable "+RTS -A128m -n2m -RTS";

  # https://devenv.sh/packages/
  # NOTE: we don't need these packages in tests. This makes CI run tests faster
  packages = lib.optionals (!config.devenv.isTesting) [
    gitGui
    pkgs.ghcid
    pkgs.hlint
    inputs.tricorder.packages.${pkgs.stdenv.system}.tricorder
  ];

  enterShell = ''
    export HOSTNAME="''${HOSTNAME}"
    export LD_LIBRARY_PATH=${pkgs.lib.makeLibraryPath config.packages}
    # Build tools stack compiles from the snapshot (sydtest-discover, which the
    # test suite runs as a GHC preprocessor) are not on PATH by default, so HLS
    # cannot load test/*/Spec.hs without this.
    if snapshot_bin="$(stack path --snapshot-install-root 2>/dev/null)"; then
      export PATH="$snapshot_bin/bin:$PATH"
    fi
    mkdir -p $UPLOAD_DIR
    echo "Everything is ready, welcome to $GREET"
  '';

  # https://devenv.sh/languages/
  languages.nix.enable = true;
  languages.haskell.enable = true;
  languages.haskell.package = pkgsUnstable.haskell.compiler.${ghc};
  languages.haskell.lsp.package = hsPkgs.haskell-language-server;

  # See full reference at https://devenv.sh/reference/options/
}
