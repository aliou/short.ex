defmodule Short do
  @moduledoc """
  Short is URL shortener toolkit.
  """

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
end
