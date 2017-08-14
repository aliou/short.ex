defmodule Short.Adapters.InMemoryAdapter do
  @moduledoc """
  Store shortened URLs in memory.

  This is the default adapter and is started with the Short Application.
  """

  use Short.Adapter

  alias Short.{Code, CodeAlreadyExistsError, CodeNotFoundError, URL}

  ## Agent setup

  @doc "Starts the Adapter Agent"
  def start_link do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  ## Child specification

  @doc false
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  ## Short Adapter implementation

  @impl Short.Adapter
  def get(%Code{} = code) do
    case Map.fetch(all(), code) do
      {:ok, url} -> {:ok, url}
      :error -> {:error, CodeNotFoundError.exception(code)}
    end
  end

  @impl Short.Adapter
  # TODO: This is refactorable using `with` I think.
  def create(%URL{} = url, %Code{} = code) do
    if code_exists?(code) do
      {:error, CodeAlreadyExistsError.exception(code)}
    else
      case fetch_code(url) do
        nil -> {:ok, add(code, url)}
        {existing_code, ^url} -> {:ok, {existing_code, url}}
      end
    end
  end

  ## Agent helpers.

  @doc false
  def clear!, do: Agent.update(__MODULE__, (fn(_) -> %{} end))

  # TODO: Better names?
  defp all, do: Agent.get(__MODULE__, fn(urls) -> urls end)
  defp code_exists?(code), do: Map.has_key?(all(), code)
  defp fetch_code(url), do: all() |> Enum.find(fn ({_, v}) -> url == v end)
  defp add(code, url) do
    Agent.update(__MODULE__, fn(urls) -> Map.put(urls, code, url) end)
    {code, url}
  end
end
