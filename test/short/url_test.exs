defmodule Short.URLTest do
  use ExUnit.Case, async: true

  import Short.URL
  doctest Short.URL

  describe "type/0" do
    test "it stores the URLs as strings." do
      assert Short.URL.type == :string
    end
  end

  describe "cast/1" do
    test "it returns the string representation of the URL when it is a Short URL" do
      url = Short.URL.new(Faker.Internet.url())
      assert Short.URL.cast(url) == {:ok, to_string(url)}
    end

    test "it returns an error when it is something other" do
      assert Short.URL.cast(1) == :error
    end
  end

  describe "load/1" do
    test "it returns the URL when getting from the database" do
      url = Faker.Internet.url()
      assert Short.URL.load(url) == {:ok, Short.URL.new(url)}
    end
  end

  describe "dump/1" do
    test "it returns the string representation of the URL when it is a Short URL" do
      url = Short.URL.new(Faker.Internet.url())
      assert Short.URL.dump(url) == {:ok, to_string(url)}
    end

    test "it returns an error when it is something other" do
      assert Short.URL.dump(1) == :error
    end
  end
end
