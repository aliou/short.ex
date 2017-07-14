defmodule Short.Adapter do
  @moduledoc """
  Behaviour for creating a Short adapter.
  """

  @typedoc """
  For now just a regular String. In the future, we might want to limit what this
  type is: For example, we only want characters that are permitted in an URL to
  be used for the code, or we might want to limit the number of characters
  for the code.
  """
  @type code :: String.t

  @typedoc """
  Either a regular String or a URI if we want more control.

  TODO: Check if it is neccessary to have two possible types here.
  """
  @type url :: String.t | URI.t

  @typedoc """
  A wrapper around a shortened URL.

  TODO: Find a better name for this type.
  """
  @type shortened_url :: {code, url}

  @typedoc """
  Possible errors occuring when fetching or shortening an URL.

  TODO: Find a better name for this type.
  """
  @type error :: Short.CodeNotFoundError.t | Short.CodeAlreadyExistsError.t

  @callback fetch_url(code) :: {:ok, url} | {:error, error}
  @callback shorten(url, code | nil) :: {:ok, shortened_url} | {:error, error}
end
