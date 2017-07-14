defmodule Short.InMemoryAdapter do
  @moduledoc """
  Store shortened URLs in memory.

  Because this adapter is using an Agent, make sure it is started with the
  Application.
  """

  @behaviour Short.Adapter

  @code_length 3

  alias Short.{CodeAlreadyExistsError, CodeNotFoundError}

  @doc "Starts the Adapter Agent"
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @impl Short.Adapter
  @spec fetch_url(String.t) :: {:ok, String.t} | {:error, CodeNotFoundError.t}
  def fetch_url(code) do
    case Map.fetch(all(), code) do
      {:ok, url} -> {:ok, url}
      :error -> {:error, CodeNotFoundError.exception(code)}
    end
  end

  @impl Short.Adapter
  @spec shorten(String.t, String.t | nil) ::
    {:ok, {String.t, String.t}} | {:error, CodeAlreadyExistsError.t}
  def shorten(url, code \\ nil)

  def shorten(url, nil) do
    shorten(url, generate_code())
  end

  def shorten(url, code) do
    if code_exists?(code) do
      {:error, CodeAlreadyExistsError.exception(code)}
    else
      case fetch_code(url) do
        nil -> {:ok, add(code, url)}
        {existing_code, ^url} -> {:ok, {existing_code, url}}
      end
    end
  end

  defp generate_code do
    @code_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, @code_length)
  end

  defp all, do: Agent.get(__MODULE__, fn(urls) -> urls end)
  defp code_exists?(code), do: Map.has_key?(all(), code)
  defp fetch_code(url), do: all() |> Enum.find(fn ({_, v}) -> url == v end)
  defp add(code, url) do
    Agent.update(__MODULE__, fn(urls) -> Map.put(urls, code, url) end)
    {code, url}
  end
end
