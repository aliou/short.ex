ExUnit.start()

# Use the InMemoryAdapter for tests.
Application.put_env(:short, :adapter, Short.Adapters.InMemoryAdapter)
{:ok, _} = Short.Adapters.InMemoryAdapter.start_link
