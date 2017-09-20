if Code.ensure_loaded?(Ecto) do
  defmodule Short.Adapters.Ecto.Queries do
    @moduledoc false

    import Ecto.Query
    alias Short.Adapters.Ecto.Schema

    @doc false
    @spec find_code(Short.Code.t) :: Ecto.Query.t
    def find_code(%Short.Code{} = code) do
      from u in Schema,
      where: u.code == ^code
    end

    @doc false
    @spec find_url(Short.URL.t) :: Ecto.Query.t
    def find_url(%Short.URL{} = url) do
      from u in Schema,
      where: u.url == ^url
    end

    @doc false
    @spec get_url(Short.Code.t) :: Ecto.Query.t
    def get_url(%Short.Code{} = code) do
      from u in find_code(code),
      select: u.url
    end
  end
end
