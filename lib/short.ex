defmodule Short do
  @moduledoc false

  use Application

  defmodule CodeNotFoundError do
    defexception [:message, :code]

    @type t :: Exception.t

    def exception(code) do
      %__MODULE__{
        code: code,
        message: "URL for code \"#{code}\" was not found."
      }
    end
  end

  defmodule CodeAlreadyExistsError do
    defexception [:message, :code]

    @type t :: Exception.t

    def exception(code) do
      %__MODULE__{
        code: code,
        message: "Code \"#{code}\" already exists."
      }
    end
  end

  def start(_type, _args) do
    import Supervisor.Spec

    # TODO: Only add the memory adapter if it is the selected adapter.
    children = [
      worker(Short.InMemoryAdapter, []),
    ]

    opts = [strategy: :one_for_one, name: Short.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
