ExUnit.start()

# Use the InMemoryAdapter for tests.
Application.put_env(:short, :adapter, Short.InMemoryAdapter)
{:ok, _} = Short.InMemoryAdapter.start_link
