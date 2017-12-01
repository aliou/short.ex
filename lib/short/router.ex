defmodule Short.Router do
  @moduledoc """
  Router for Short.

  TODO: Docs about how to either forward to this from another plug, or directly
  using this with cowboy.
  """

  use Plug.Router

  plug Plug.Parsers, parsers: [:multipart], pass: ["*/*"]
  plug :match
  plug :dispatch

  get "/:code" do
    case adapter().get(code) do
      {:ok, url} -> redirect(conn, to_string(url))
      {:error, _} -> conn |> send_resp(404, "code not found")
    end
  end

  post "/" do
    url = conn.params["url"]
    code = conn.params["code"]

    case adapter().create(url, code) do
      {:ok, {code, _url}} -> conn |> send_resp(200, "#{code}")
      {:error, error} -> conn |> send_resp(422, error.message)
    end
  end

  match _, do: send_resp(conn, 404, "not found")

  ## Helpers

  defp adapter do
    get_adapter(Application.get_env(:short, :adapter))
  end

  defp get_adapter(nil) do
    message = """
    the adapter config is not defined, please define it in your config with
        config :short, :adapter, MyCustomAdapter

    Using the in memory adapter as a default adapter.
    """

    IO.warn(message, [])

    Short.Adapters.InMemory
  end

  defp get_adapter(defined_adapter), do: defined_adapter

  defp redirect(conn, to) do
    conn
    |> put_resp_header("location", to)
    |> resp(301, "You are being redirected.")
    |> halt()
  end
end
