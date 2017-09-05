use Mix.Config

# This is needed so the `use` in the test repo correctly works.
config :short, Short.Adapters.Ecto.Repo,
  adapter: Ecto.Adapters.Postgres,
  database: "short_test_repo",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :short, ecto_repos: [Short.Adapters.Ecto.Repo]
