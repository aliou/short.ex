defmodule Short.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    import Supervisor.Spec

    # TODO: Is there a better way to do this? Also there should be a way to
    # configure this, when using a custom adapter.
    children = case Application.get_env(:short, :adapter) do
      Short.InMemoryAdapter -> [worker(Short.InMemoryAdapter, [])]
      _ -> []
    end

    opts = [strategy: :one_for_one, name: Short.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
