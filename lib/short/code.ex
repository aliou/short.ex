defmodule Short.Code do
  @moduledoc false

  @typedoc false
  @type t :: String.t

  @spec generate :: Short.Code.t
  def generate do
    code_length()
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, code_length())
  end

  ## Helpers

  @default_code_length 3
  defp code_length do
    Application.get_env(:short, :code_length, @default_code_length)
  end
end
