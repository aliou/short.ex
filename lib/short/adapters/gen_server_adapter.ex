defmodule Short.Adapters.GenServerAdapter do
  @moduledoc """
  Store shortened URLs in a GenServer.

  This implementation really needs to be improved. /shrug.
  """

  alias Short.{CodeAlreadyExistsError, CodeNotFoundError}

  use GenServer
  use Short.Adapter

  ## Child specification

  @doc false
  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []}
    }
  end

  ## Client API.

  def start_link do
    GenServer.start_link(__MODULE__, [urls: %{}, codes: %{}], name: __MODULE__)
  end

  @impl Short.Adapter
  def get(%Short.Code{} = code), do: GenServer.call(__MODULE__, {:get, code})

  @impl Short.Adapter
  def create(%Short.URL{} = url, %Short.Code{} = code) do
    GenServer.call(__MODULE__, {:create, url, code})
  end

  ## Server API

  @impl GenServer
  def handle_call(request, from, state)

  def handle_call({:get, code}, _from, [urls: _urls, codes: codes] = state) do
    reply = case Map.fetch(codes, code) do
      {:ok, url} -> {:ok, url}
      :error -> {:error, CodeNotFoundError.exception(code)}
    end

    {:reply, reply, state}
  end

  def handle_call({:create, url, code}, _from, state) do
    if code_exists?(code, state) do
      {:reply, {:error, CodeAlreadyExistsError.exception(code)}, state}
    else
      case fetch_code(url, state) do
        nil -> {:reply, {:ok, {code, url}}, add({code, url}, state)}
        existing_code -> {:reply, {:ok, {existing_code, url}}, state}
      end
    end
  end

  def handle_call(:clear, _from, _state) do
    {:noreply, [urls: %{}, codes: %{}]}
  end

  ## Helpers

  @doc false
  def clear!, do: GenServer.call(__MODULE__, :clear)

  defp add({code, url}, [urls: urls, codes: codes]) do
    [
      urls: Map.merge(urls, %{url => code}),
      codes: Map.merge(codes, %{code => url})
    ]
  end

  def fetch_code(url, [urls: urls, codes: _]) do
    Map.get(urls, url)
  end

  defp code_exists?(code, [urls: _, codes: codes]) do
    Map.has_key?(codes, code)
  end
end
