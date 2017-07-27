defmodule Short.Application do
  @moduledoc false

  use Application

  alias Short.Adapters.InMemoryAdapter

  def start(_type, _args) do
    children = [InMemoryAdapter]

    opts = [strategy: :one_for_one, name: Short.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
