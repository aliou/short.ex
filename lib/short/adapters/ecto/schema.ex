# Don't bother defining the schema if Ecto is not here.
if Code.ensure_loaded?(Ecto) do
  defmodule Short.Adapters.Ecto.Schema do
    @moduledoc """
    """

    use Ecto.Schema

    # Allow configurable table name?
    schema "short_urls" do
      field :code, Short.Code
      field :url, Short.URL

      timestamps()
    end
  end
end
