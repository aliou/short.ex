# Short

A URL shortener toolkit written in Elixir, inspired by [Guillotine][guillotine].

## Usage

The easiest way to get started is to use the built-in Plug Router and memory adapter.

First create a supervised application :
```shell
$ mix new my_app --sup
```

Add Short to your dependencies and applications, along with the Cowboy
web server:

```elixir
# mix.exs

def application do
  [applications: [:short, :cowboy]]
end

defp deps do
[
  ...
  {:short, "~> 0.1.0"},
  {:cowboy, "~> 1.0.0"},
  ...
]
```

Configure Short to use the In Memory Adapter:
```elixir
# config/config.exs

config :short, :adapter, Short.Adapters.InMemoryAdapter
```

Finally, add the router to your application's supervisor tree:
```elixir
# lib/my_app.ex

defmodule MyApp do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Define workers and child supervisors to be supervised
      Plug.Adapters.Cowboy.child_spec(:http, Short.Router, [], [port: 4001])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MyApp.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
```

Once you have your application running, you can add URLs with a POST request:
```shell
$ curl http://localhost:4001 -i \
>   -F "url=https://aliou.me"
```

You can also specify your own code too:
```shell
$ curl http://localhost:4001 -i \
>   -F "url=https://aliou.me"
>   -F "code=abc"
```

[guillotine]: https://github.com/technoweenie/guillotine
