defmodule Short.Adapters.GenServerAdapterTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
  alias Short.Adapters.GenServerAdapter

  setup do
    {:ok, _adapter} = GenServerAdapter.start_link
    :ok
  end

  describe "get/1" do
    test "it returns an error when the code doesn't exist" do
      code = "abc"

      assert {:error, %CodeNotFoundError{code: %Short.Code{__code: ^code}}} =
        GenServerAdapter.get(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.generate()

      GenServerAdapter.create(url, code)

      assert {:ok, ^url} = GenServerAdapter.get(code)
    end
  end

  describe "create/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url |> Short.URL.new()
      assert {:ok, {_code, ^url}} = GenServerAdapter.create(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      assert {:ok, {^code, ^url}} = GenServerAdapter.create(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      GenServerAdapter.create(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        GenServerAdapter.create(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      GenServerAdapter.create(url, code)

      assert {:ok, {^code, ^url}} = GenServerAdapter.create(url)
    end
  end
end
