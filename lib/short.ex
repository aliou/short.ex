defmodule Short do
  @moduledoc """
  Short is a URL shortening toolkit. It can be used by itself using the builtin
  Plug or within other web applications by forwarding to `Short.Router`.

  The storing of the URLs and their codes is handled through adapters. See the
  `Short.Adapter` documentation for instructions on how to implement one and
  `Short.Adapters.InMemory` for an implementation example.
  """

  defmodule CodeNotFoundError do
    defexception [:message, :code]

    @type t :: Exception.t

    @spec exception(Short.Code.t) :: t
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

    @spec exception(Short.Code.t) :: t
    def exception(code) do
      %__MODULE__{
        code: code,
        message: "Code \"#{code}\" already exists."
      }
    end
  end
end
