# In tests, we need to mimic an application using the Ecto adapter. One of the
# requirement of this adapter is an Ecto Repo, and creating one in
# `test_helper.exs` didn't seem to work, so we create one here and restrict it
# to the test environment to prevent other apps from using it.
if Code.ensure_loaded?(Ecto) && Mix.env == :test do
  defmodule Short.Adapters.Ecto.Repo do
    @moduledoc false

    use Ecto.Repo, otp_app: :short
  end
end
