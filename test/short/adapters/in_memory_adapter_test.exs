defmodule Short.Adapters.InMemoryAdapterTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
  alias Short.Adapters.InMemoryAdapter

  setup do
    Short.Adapters.InMemoryAdapter.clear!
    :ok
  end

  describe "get/1" do
    test "it returns an error when the code doesn't exist" do
      code = Short.Code.new("abc")

      assert {:error, %CodeNotFoundError{code: ^code}} =
        InMemoryAdapter.get(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.generate()

      InMemoryAdapter.create(url, code)

      assert {:ok, ^url} = InMemoryAdapter.get(code)
    end
  end

  describe "create/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url |> Short.URL.new()
      assert {:ok, {_code, ^url}} = InMemoryAdapter.create(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      assert {:ok, {^code, ^url}} = InMemoryAdapter.create(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      InMemoryAdapter.create(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        InMemoryAdapter.create(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      InMemoryAdapter.create(url, code)

      assert {:ok, {^code, ^url}} = InMemoryAdapter.create(url)
    end
  end
end
