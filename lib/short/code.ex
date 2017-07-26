defmodule Short.Code do
  @moduledoc """
  A Short Code.

  This module defined a Short Code and the main functions for working with Short
  Codes.
  """

  @enforce_keys [:__code]
  defstruct [:__code]

  @type t :: %__MODULE__{
    __code: String.t
  }

  @doc """
  Returns a new Wrapped code.

  ## Examples

      iex> Short.Code.new("abc")
      %Short.Code{__code: "abc"}

      iex> Short.Code.new("?!&")
      %Short.Code{__code: "?!&"}

  """
  @spec new(String.t) :: t
  def new(code), do: %Short.Code{__code: code}

  @doc """
  Generates valid code.

  By default, the code will be of `default_code_length` length. Short allows
  this default code length to be overriden through the Mix configuration of the
  `:short` application. For example, to override the length, the following
  config can be specified:

      config :short, :code_length, 7
  """
  @spec generate(integer) :: Short.Code.t
  def generate(length \\ 0)

  def generate(0), do: generate(code_length())
  def generate(length) do
    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, length)
    |> new()
  end

  @doc """
  Check if the code is valid to be used in an URI.

  ## Examples

      iex> Short.Code.valid?("abc")
      true

      iex> Short.Code.valid?("?!&")
      false

  """
  @spec valid?(Short.Code.t | String.t) :: boolean
  def valid?(code) when is_binary(code) do
    code
    |> String.to_charlist()
    |> Enum.all?(&URI.char_unreserved?/1)
  end

  def valid?(%Short.Code{} = code), do: code |> to_string() |> valid?()

  ## Helpers

  @doc false
  def default_code_length, do: 3

  # This is obviously overkill but ya boy aliou wants to learn things.
  defp code_length do
    Application.get_env(:short, :code_length, default_code_length())
  end

  @doc false
  @spec length(t) :: integer
  def length(code), do: String.length(code.__code)
end

# Allow `Short.Code`s to be interpolated in strings.
defimpl String.Chars, for: Short.Code do
  def to_string(code), do: code.__code
end

# Hide internal implementation in IEx. No reason, I just want to.
defimpl Inspect, for: Short.Code do
  @inspected inspect(@for)

  def inspect(code, _), do: "#" <> @inspected <> "<" <> to_string(code) <> ">"
end
