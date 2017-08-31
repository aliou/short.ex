defmodule Short.Adapters.InMemoryTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
  alias Short.Adapters.InMemory

  setup do
    Short.Adapters.InMemory.clear!
    :ok
  end

  describe "get/1" do
    test "it returns an error when the code doesn't exist" do
      code = Short.Code.new("abc")

      assert {:error, %CodeNotFoundError{code: ^code}} =
        InMemory.get(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.generate()

      InMemory.create(url, code)

      assert {:ok, ^url} = InMemory.get(code)
    end
  end

  describe "create/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url |> Short.URL.new()
      assert {:ok, {_code, ^url}} = InMemory.create(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      assert {:ok, {^code, ^url}} = InMemory.create(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      InMemory.create(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        InMemory.create(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      InMemory.create(url, code)

      assert {:ok, {^code, ^url}} = InMemory.create(url)
    end
  end
end
