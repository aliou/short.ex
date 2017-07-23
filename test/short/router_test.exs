defmodule Short.RouterTest do
  use ExUnit.Case
  use Plug.Test

  @options Short.Router.init([])

  setup do
    Short.Adapters.InMemoryAdapter.clear!
    :ok
  end

  describe "GET /:code" do
    test "it returns 404 when the code doesn't exist" do
      code = Short.Code.generate()
      conn = conn(:get, "/#{code}") |> Short.Router.call(@options)

      assert conn.status == 404
    end

    test "it redirects to the associated url when the code exists" do
      code = Short.Code.generate()
      url = Faker.Internet.url

      adapter = Application.get_env(:short, :adapter)
      {:ok, _} = adapter.create(url, code)
      conn = conn(:get, "/#{code}") |> Short.Router.call(@options)

      assert conn.status == 301
      assert [url] == Plug.Conn.get_resp_header(conn, "location")
    end
  end

  describe "POST /" do
    test "it returns the code when shortening an URL" do
      code = Short.Code.generate()
      url = Faker.Internet.url

      conn =
        conn(:post, "/", %{code: code, url: url})
        |> Plug.Conn.put_resp_header("content-type", "multipart/form-data")
        |> Short.Router.call(@options)

      assert conn.status == 200
      assert conn.resp_body == code
    end

    test "it returns an error when there is an error" do
      code = Short.Code.generate()
      url = Faker.Internet.url

      adapter = Application.get_env(:short, :adapter)
      {:ok, _} = adapter.create(url, code)
      conn =
        conn(:post, "/", %{code: code, url: url})
        |> Plug.Conn.put_resp_header("content-type", "multipart/form-data")
        |> Short.Router.call(@options)

      assert conn.status == 422
      assert conn.resp_body ==
        Short.CodeAlreadyExistsError.exception(code).message
    end
  end
end
