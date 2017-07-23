defmodule Short.InMemoryAdapterTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError, InMemoryAdapter}

  setup do
    Short.InMemoryAdapter.clear!
  end

  describe "fetch_url/1" do
    test "it returns an error when the code doesn't exist" do
      code = "abc"

      assert {:error, %CodeNotFoundError{code: ^code}} =
        InMemoryAdapter.fetch_url(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url
      code = "abc"

      InMemoryAdapter.shorten(url, code)

      assert {:ok, ^url} = InMemoryAdapter.fetch_url(code)
    end
  end

  describe "shorten/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url
      assert {:ok, {_code, ^url}} = InMemoryAdapter.shorten(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url
      code = "my-custom-code"

      assert {:ok, {^code, ^url}} = InMemoryAdapter.shorten(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url
      code = "my-custom-code"

      InMemoryAdapter.shorten(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        InMemoryAdapter.shorten(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url
      code = "my-custom-code"

      InMemoryAdapter.shorten(url, code)

      assert {:ok, {^code, ^url}} = InMemoryAdapter.shorten(url)
    end
  end
end
