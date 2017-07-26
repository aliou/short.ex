Application.put_env(:short, :adapter, Short.Adapters.InMemoryAdapter)
Application.ensure_all_started(:short)

ExUnit.start()
