defmodule Short.Mixfile do
  use Mix.Project

  def project do
    [
      app: :short,
      version: "0.0.1",
      elixir: "~> 1.0",
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: aliases(),
      description: description(),
      package: package(),

      # Docs
      name: "Short",
      source_url: "https://github.com/aliou/short.ex",
      docs: [main: "readme", # The main page in the docs
             extras: ["README.md"]]
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [
      mod: {Short.Application, []},
      extra_applications: [:logger]
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:my_dep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:my_dep, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [
      # Router.
      {:plug, "~> 1.0"},

      # Development tools.
      {:credo, "~> 0.8", only: [:dev, :test], runtime: false},
      {:faker, "~> 0.8", only: [:dev, :test]},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},

      # Docs
      {:ex_doc, "~> 0.14", only: :dev, runtime: false},

      # Adapter deps.
      {:ecto, only: [:dev, :test]},
      {:postgrex, only: [:dev, :test]},
    ]
  end

  defp aliases, do: []

  defp description do
    "A URL shortener toolkit."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Aliou Diallo"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/aliou/short.ex"}
    ]
  end
end
