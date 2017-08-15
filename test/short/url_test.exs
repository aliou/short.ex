defmodule Short.URLTest do
  use ExUnit.Case, async: true

  import Short.URL
  doctest Short.URL

  test "should allow well formed URL" do
    assert true = Short.URL.new("https://github.com/") |> Short.URL.valid?
  end

  test "should error on a non http/https URL" do
    refute Short.URL.new("ftp://github.com/") |> Short.URL.valid?
  end

  test "should error on no scheme" do
    refute Short.URL.new("weuiewougew") |> Short.URL.valid?
  end

  test "should error on invalid hostname" do
    refute Short.URL.new("http://ewoweowe/") |> Short.URL.valid?
  end
end
