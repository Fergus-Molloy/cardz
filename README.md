# Cardz

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

# Running with nix
To start all required dependencies and the phoenix server use `nix run`. To run only the database use `nix run .#db`, this allows you
to run the phoenix server seperately with either `mix phx.server` or `iex -S mix phx.server`.
Once everything is running check you can access [`localhost:4000`](http://localhost:4000).

If this is your first time running the project make sure to run `mix deps.get`, `mix ecto.setup`.
These will download the dependencies, create and migrate the database and also add example data.
If you would like to delete the sample data or delete all data in the database then run `mix ecto.reset`.

If you do not have mix in your environment then you can run `nix develop` which will put you in a shell with all the tools required
to run the project, including a helper script `pg-connect` which will connect you to the running database using the postgres user.
Note that the postgres user does not have certain permissions like the ability to create new databases. This is because, by default
the flake will create a user with the same username as the current user with full permissions. If you want to use this account to access
the database you can use the `pg-user-connect` script instead.
