defmodule Short.Adapters.GenServerTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
  alias Short.Adapters.GenServer

  setup do
    {:ok, _adapter} = GenServer.start_link
    :ok
  end

  describe "get/1" do
    test "it returns an error when the code doesn't exist" do
      code = "abc"

      assert {:error, %CodeNotFoundError{code: %Short.Code{__code: ^code}}} =
        GenServer.get(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.generate()

      GenServer.create(url, code)

      assert {:ok, ^url} = GenServer.get(code)
    end
  end

  describe "create/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url |> Short.URL.new()
      assert {:ok, {_code, ^url}} = GenServer.create(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      assert {:ok, {^code, ^url}} = GenServer.create(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      GenServer.create(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        GenServer.create(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      GenServer.create(url, code)

      assert {:ok, {^code, ^url}} = GenServer.create(url)
    end
  end
end
