defmodule Mix.Tasks.Short.Ecto.Install do
  # Heavily inspired by Papertail install task.
  @shortdoc "generates short migration file for your database"

  use Mix.Task

  import Macro, only: [underscore: 1]
  import Mix.Generator

  def run(_args) do
    migrations_folder = Path.relative_to("priv/repo/migrations", Mix.Project.app_path)
    file_name = "#{timestamp()}_#{underscore(AddShortUrls)}.exs"
    file_path = Path.join(migrations_folder, file_name)

    create_directory(migrations_folder)

    create_file file_path, """
    defmodule Repo.Migrations.AddShortUrls do
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

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)
end
