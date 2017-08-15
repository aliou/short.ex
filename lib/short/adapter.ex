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
end
