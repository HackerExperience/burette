defmodule Burette.Name do

  @lang Application.get_env(:burette, :locale, "en_US")
  @default_provider Burette.Helper.Module.to_module(__MODULE__, "en_US")
  @chosen_provider Burette.Helper.Module.to_module(__MODULE__, @lang)
  @provider Code.ensure_loaded?(@chosen_provider) && @chosen_provider || @default_provider

  @callback name() :: String.t
  @callback surname() :: String.t
  @callback fullname() :: String.t
  @callback lexicons() :: %{atom => Burette.Lexicon.t}

  defdelegate name,
    to: @provider
  defdelegate surname,
    to: @provider
  defdelegate fullname,
    to: @provider

  @doc false
  defdelegate lexicons,
    to: @provider
end
