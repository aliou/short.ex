if Code.ensure_loaded?(Ecto) && Mix.env == :test do
  defmodule Short.Adapters.Ecto.Repo do
    @moduledoc false

    use Ecto.Repo, otp_app: :short
  end
end
