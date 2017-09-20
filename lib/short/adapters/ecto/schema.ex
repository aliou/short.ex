# Don't bother defining the schema if Ecto is not here.
if Code.ensure_loaded?(Ecto) do
  defmodule Short.Adapters.Ecto.Schema do
    @moduledoc """
    The schema used to map the Short URLs to an Elixir struct.
    """

    use Ecto.Schema
    import Ecto.Changeset

    # Allow configurable table name?
    schema "short_urls" do
      field :code, Short.Code
      field :url, Short.URL

      timestamps()
    end

    def changeset(short_url, params \\ %{}) do
      short_url
      |> cast(params, [:code, :url])
      |> validate_required([:code, :url])
      |> unique_constraint(:code)
    end
  end
end
