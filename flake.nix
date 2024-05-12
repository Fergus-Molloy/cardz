{
  description = "A flake to run all services needed for development of cardz";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    process-compose-flake.url = "github:Platonic-Systems/process-compose-flake";
    services-flake.url = "github:juspay/services-flake";
  };
  outputs = inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = import inputs.systems;
      imports = [
        inputs.process-compose-flake.flakeModule
      ];
      perSystem = { self', pkgs, lib, ... }:
        let

          db-name = "cardz_dev";
          pg-host = "127.0.0.1";
        in
        {
          # This adds a `self.packages.default`
          process-compose."default" = { config, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];

              services.postgres."pg" = {
                enable = true;
                listen_addresses = "127.0.0.1";
                initialDatabases = [
                  {
                    name = db-name;
                  }
                ];
              };
            };

          devShells.default =
            let
              user = "fergus"; # change me to your user
            in
            pkgs.mkShell {
              PGUSER = user;
              buildInputs = with pkgs;
                [
                  elixir
                  elixir-ls

                  nodejs_20

                  postgresql

                  nil
                  nixpkgs-fmt
                  (pkgs.writeShellScriptBin "pg-connect" ''
                    psql -h "${pg-host}" -d "${db-name}"
                  '')
                ] ++ lib.optional stdenv.isLinux inotify-tools;
            };
        };
    };
}
