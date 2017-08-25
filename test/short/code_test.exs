defmodule Short.CodeTest do
  use ExUnit.Case, async: true
  doctest Short.Code

  describe "generate/0" do
    test "it generates a code of default length when not configured nor given" do
      code = Short.Code.generate()

      assert Short.Code.length(code) == Short.Code.default_code_length()
    end

    test "it generates a code of the configured length when non given" do
      configured_code_length = :rand.uniform(100)
      Application.put_env(:short, :code_length, configured_code_length)

      on_exit fn ->
        Application.delete_env(:short, :code_length)
      end

      code = Short.Code.generate()
      assert Short.Code.length(code) == configured_code_length
    end

    test "it generates a code of the given length when given" do
      given_code_length = :rand.uniform(100)
      # Unlikely, but make sure the configured code length is != than the given
      # length.
      generator = (fn -> :rand.uniform(100) end)
      configured_code_length =
        generator
        |> Stream.repeatedly()
        |> Enum.find(fn(code_length) -> code_length != given_code_length end)

      Application.put_env(:short, :code_length, configured_code_length)

      on_exit fn ->
        Application.delete_env(:short, :code_length)
      end

      code = Short.Code.generate(given_code_length)
      assert Short.Code.length(code) == given_code_length
      assert Short.Code.length(code) != configured_code_length
    end
  end
end
