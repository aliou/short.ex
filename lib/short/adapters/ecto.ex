# Only load Ecto adapter if Ecto is loaded.
if Code.ensure_loaded?(Ecto) do
  defmodule Short.Adapters.Ecto do
    @moduledoc """
    """

    use Short.Adapter
    alias Short.{CodeNotFoundError, CodeAlreadyExistsError}
    alias Short.{Code, URL}
    alias Short.Adapters.Ecto.Schema

    @impl Short.Adapter
    def get(%Code{} = code) do
      query = Short.Adapters.Ecto.Queries.get_url(code)

      case repo().one(query) do
        nil -> {:error, CodeNotFoundError.exception(code)}
        url -> {:ok, url}
      end
    end

    @impl Short.Adapter
    def create(%URL{} = url, %Code{} = code) do
      with nil <- find_code(code),
          {:ok, url} <- find_or_create(url, code)
      do
        {:ok, {url.code, url.url}}
      else
        %Schema{code: ^code} -> {:error, CodeAlreadyExistsError.exception(code)}
      end
    end

    ## Helpers

    # TODO: Raise a custom error when the repo isn't configured.
    defp repo do
      case Application.fetch_env(:short, :ecto_repo) do
        {:ok, repo} -> repo
        :error -> raise "Missing repo in configuration"
      end
    end

    defp find_or_create(url, code) do
      search_query = Short.Adapters.Ecto.Queries.find_url(url)
      changeset = Schema.changeset(%Schema{}, %{url: url, code: code})

      case repo().one(search_query) do
        nil -> repo().insert(changeset)
        url -> {:ok, url}
      end
    end

    defp find_code(code) do
      code
      |> Short.Adapters.Ecto.Queries.find_code()
      |> repo().one()
    end
  end
end
