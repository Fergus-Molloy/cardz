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
          postgres = {
            enable = true;
            listen_addresses = pg-host;
            initialDatabases = [
              {
                name = db-name;
              }
            ];
            initialScript.after = ''
              CREATE USER postgres WITH PASSWORD 'postgres' SUPERUSER;
              GRANT ALL PRIVILEGES ON DATABASE ${db-name} TO postgres;
              GRANT ALL PRIVILEGES ON SCHEMA public TO postgres;
            '';
          };
        in
        {
          # This adds a `self.packages.default`
          process-compose."default" = { config, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              settings = {
                processes = {
                  "phoenix" = {
                    command = "mix phx.server";
                    depends_on."pg".condition = "process_healthy";
                  };
                };
              };

              services.postgres."pg" = postgres;
            };
          process-compose."db" = { config, ... }:
            {
              imports = [
                inputs.services-flake.processComposeModules.default
              ];
              services.postgres."pg" = postgres;
            };

          # in theory this is how you package the app to be run using nix however it doesn't work
          # due to mix trying to install tailwind itself when `mix assets.deploy` is run
          # packages.cardz =
          #   let
          #     beamPackages = with pkgs; beam.packagesWith beam.interpreters.erlang;
          #     pname = "cardz";
          #     version = "0.1.0";
          #     src = ./.;
          #     mixFodDeps = beamPackages.fetchMixDeps {
          #       pname = "mix-deps-${pname}";
          #       inherit src version;
          #       sha256 = "gmk8Gx2aSF6jzTv8bHI5Bhlf0xXUZWg6JvOtbrk+TDk=";
          #     };
          #   in
          #   pkgs.mixRelease
          #     {
          #       inherit pname version src mixFodDeps;
          #       buildInputs = with pkgs;[ nodePackages.tailwindcss ];
          #       removeCookie = false; # makes output non-deterministic
          #       mixNix = ./deps.nix;
          #       releaseType = "escript";
          #       postBuild = ''
          #         mix assets.deploy
          #       '';
          #     };

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs;
              [
                elixir
                elixir-ls
                mix2nix

                nodejs_20

                postgresql

                nil
                nixpkgs-fmt
                (pkgs.writeShellScriptBin "pg-connect" ''
                  PGPASSWORD="postgres" psql -U postgres -h "${pg-host}" -d "${db-name}"
                '')
                (pkgs.writeShellScriptBin "pg-user-connect" ''
                  psql -h "${pg-host}" -d "${db-name}"
                '')
              ] ++ lib.optional stdenv.isLinux inotify-tools;
          };
        };
    };
}
