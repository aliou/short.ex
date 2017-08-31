defmodule Short.Application do
  @moduledoc false

  use Application

  alias Short.Adapters.InMemory

  def start(_type, _args) do
    children = [InMemory]

    opts = [strategy: :one_for_one, name: Short.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
