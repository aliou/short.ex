defmodule Short.Adapters.EctoAdapterTest do
  use ExUnit.Case, async: true

  alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
  alias Short.Adapters.Ecto, as: EctoAdapter

  setup_all do
    {:ok, _pid} = Short.Adapters.Ecto.Repo.start_link
    Ecto.Adapters.SQL.Sandbox.mode(Short.Adapters.Ecto.Repo, :manual)

    :ok
  end

  setup do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Short.Adapters.Ecto.Repo)
  end

  describe "get/1" do
    test "it returns an error when the code doesn't exist" do
      code = "abc"

      assert {:error, %CodeNotFoundError{code: %Short.Code{__code: ^code}}} =
        EctoAdapter.get(code)
    end

    test "it returns the code and the URL when the code exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.generate()

      EctoAdapter.create(url, code)

      assert {:ok, ^url} = EctoAdapter.get(code)
    end
  end

  describe "create/2" do
    test "it generates a code when nil is given" do
      url = Faker.Internet.url |> Short.URL.new()
      assert {:ok, {_code, ^url}} = EctoAdapter.create(url)
    end

    test "it uses the given code when available" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      assert {:ok, {^code, ^url}} = EctoAdapter.create(url, code)
    end

    test "it returns an error when the code already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      EctoAdapter.create(url, code)

      assert {:error, %CodeAlreadyExistsError{code: ^code}} =
        EctoAdapter.create(url, code)
    end

    test "it returns the existing code if the URL already exists" do
      url = Faker.Internet.url |> Short.URL.new()
      code = Short.Code.new("my-custom-code")

      EctoAdapter.create(url, code)

      assert {:ok, {^code, ^url}} = EctoAdapter.create(url)
    end
  end
end
