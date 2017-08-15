defmodule Short.URL do
  @moduledoc """
  A Short URL.

  This module defines a Short URL and the main functions for working with URLs.
  """

  @enforce_keys [:__uri]
  defstruct [:__uri]

  @type t :: %__MODULE__{
    __uri: URI.t
  }

  @doc """
  Returns a new wrapped URL.

  ## Examples

      iex> new("https://aliou.me")
      %Short.URL{__uri: %URI{authority: "aliou.me", fragment: nil,
        host: "aliou.me", path: nil, port: 443, query: nil,
        scheme: "https", userinfo: nil}}

  """
  @spec new(String.t | URI.t) :: t
  def new(uri) when is_binary(uri), do: uri |> URI.parse() |> new()
  def new(%URI{} = uri), do: %Short.URL{__uri: uri}

  @valid_schemes ["https", "http"]
  @doc """
  Check if the URL is valid.

  ## Examples

      iex> "https://aliou.me" |> new() |> valid?
      true

      iex> "http://aliou.me" |> new() |> valid?
      true

      iex> "" |> new() |> valid?
      false

      iex> "ayyyyyyy" |> new() |> valid?
      false

  """
  @spec valid?(Short.URL.t) :: boolean
  def valid?(%Short.URL{__uri: uri}) do
    uri.host != nil && Enum.member?(@valid_schemes, uri.scheme)
  end
end
