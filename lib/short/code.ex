defmodule Short.Code do
  @moduledoc """
  A Short Code.

  This module defined a Short Code and the main functions for working with Short
  Codes.
  """

  @typedoc false
  @type t :: String.t

  @spec generate :: Short.Code.t
  def generate do
    code_length()
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, code_length())
  end

  @doc """
  Check if the code is valid to be used in an URI.

  ## Examples

      iex> Short.Code.valid?("abc")
      true

      iex> Short.Code.valid?("?!&")
      false

  """
  @spec valid?(Short.Code.t) :: Boolean
  def valid?(code) do
    code
    |> to_string()
    |> String.to_charlist()
    |> Enum.all?(&URI.char_unreserved?/1)
  end

  ## Helpers

  @default_code_length 3
  defp code_length do
    Application.get_env(:short, :code_length, @default_code_length)
  end
end
