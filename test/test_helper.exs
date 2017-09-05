# Setup for main application tests.
Application.put_env(:short, :adapter, Short.Adapters.InMemory)

# Setup for Ecto adapter tests.
Application.put_env(:short, :ecto_repos, [Short.Adapters.Ecto.Repo])
Application.put_env(:short, :ecto_repo, Short.Adapters.Ecto.Repo)

ExUnit.start()
