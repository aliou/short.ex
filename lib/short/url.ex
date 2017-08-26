defmodule Short.URL do
  @moduledoc """
  A Short URL.

  This module defines a Short URL and the main functions for working with URLs.
  """

  # This is pretty overkill, but /shrug.
  # Define a custom Ecto type so we can do queries using Short URLs.
  # We only say this is a behaviour if Ecto is define to silence warnings on
  # projects without Ecto.
  # TODO: See if there is another way of doing this.
  if Code.ensure_loaded?(Ecto), do: @behaviour Ecto.Type

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

  ## Ecto behaviour

  # How Ecto will store our URL.
  if Code.ensure_loaded?(Ecto), do: @impl Ecto.Type
  def type, do: :string

  # Transform anything to our custom type.
  if Code.ensure_loaded?(Ecto), do: @impl Ecto.Type
  def cast(%Short.URL{} = url), do: {:ok, url}
  def cast(url) when is_binary(url), do: {:ok, Short.URL.new(url)}
  def cast(_), do: :error

  # Transform from db to our custom type.
  if Code.ensure_loaded?(Ecto), do: @impl Ecto.Type
  def load(url) when is_binary(url), do: {:ok, Short.URL.new(url)}

  # Validate and transform into the Ecto native type.
  if Code.ensure_loaded?(Ecto), do: @impl Ecto.Type
  def dump(%Short.URL{} = url), do: {:ok, to_string(url)}
  def dump(_), do: :error
end

# Allow `Short.URL`s to be interpolated in strings.
defimpl String.Chars, for: Short.URL do
  def to_string(url), do: url.__uri |> URI.to_string()
end

# Hide internal implementation in IEx. No reason, I just want to.
defimpl Inspect, for: Short.URL do
  @inspected inspect(@for)

  def inspect(url, _), do: "#" <> @inspected <> "<" <> to_string(url) <> ">"
end
