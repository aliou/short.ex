defmodule Short.Adapter do
  @moduledoc """
  Behaviour for creating a Short adapter.
  """

  @typedoc "The code representing the shortened URL"
  @type code :: Short.Code.t

  @typedoc "The URL to be shortened"
  @type url :: Short.URL.t

  @typedoc "A wrapper around a shortened URL."
  @type shortened_url :: {code, url}

  @typedoc "Possible errors occuring when working with Short Codes."
  @type error :: Short.CodeNotFoundError.t | Short.CodeAlreadyExistsError.t

  @callback get(code) :: {:ok, url} | {:error, error}
  @callback create(url, code | nil) :: {:ok, shortened_url} | {:error, error}

  # Experimenting with macros. For now, add some convenience functions that
  # convert the "primitive" Elixir types into Short types.
  @doc false
  defmacro __using__(_opts) do
    quote do
      @behaviour Short.Adapter
      alias Short.{Code, URL}

      def get(code) when is_binary(code), do: get(Code.new(code))

      def create(url, code \\ nil)
      def create(url, nil), do: create(url, Code.generate())
      def create(url, code) when is_binary(code), do: create(url, Code.new(code))
      def create(url, code) when is_binary(url), do: create(URL.new(url), code)
    end
  end
end
