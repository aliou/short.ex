if Code.ensure_loaded?(Mix.Ecto) do
  defmodule Mix.Tasks.Short.Ecto.Install do
    use Mix.Task

    import Macro, only: [camelize: 1, underscore: 1]
    import Mix.Generator
    import Mix.Ecto

    @shortdoc "Generates a migration creating a new table for the Short app."
    @moduledoc """
    Generate a migration creating a new table for the Short application.

    The repository must be set under `:ecto_repos` in the
    current app configuration or given via the `-r` option.

    ## Examples

        mix short.ecto.install
        mix short.ecto.install -r Custom.Repo

    By default, the migration will be generated to the
    `priv/YOUR_REPO/migrations` directory of the current application
    but it can be configured to be any subdirectory of `priv` by
    specifying the `:priv` key under the repository configuration.

    ## Command line options

      * `-r`, `--repo` - the repo to generate migration for

    """

    def run(args) do
      no_umbrella!("ecto.gen.migration")
      repos = parse_repo(args)

      Enum.each repos, fn repo ->
        name = "add_short_urls"
        ensure_repo(repo, args)
        path = migrations_path(repo)
        file = Path.join(path, "#{timestamp()}_#{underscore(name)}.exs")

        create_directory(path)

        assigns = [mod: Module.concat([repo, Migrations, camelize(name)])]
        create_file file, migration_template(assigns)
      end
    end

    defp timestamp do
      {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
      "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
    end

    defp pad(i) when i < 10, do: << ?0, ?0 + i >>
    defp pad(i), do: to_string(i)

    embed_template :migration,  """
    defmodule <%= inspect @mod %> do
      use Ecto.Migration

      def change do
        create table(:short_urls) do
          add :code, :string, null: false
          add :url, :string, null: false

          timestamps()
        end

        create unique_index(:short_urls, [:code])
      end
    end
    """

  end
end
