defmodule Burette.Color do

  @lang Application.get_env(:burette, :color, "en_US")
  @default_provider Burette.Color.En.Us
  @chosen_provider Burette.Helper.Module.to_module(__MODULE__, @lang)
  @provider Code.ensure_loaded?(@chosen_provider) && @chosen_provider || @default_provider

  @callback name() :: String.t
  @callback lexicons() :: %{atom => Burette.Lexicon.t}

  @doc """
  Returns a color name
  """
  defdelegate name,
    to: @provider

  @doc false
  defdelegate lexicons,
    to: @provider

  def hex do
    color_code =
      0..0xffffff
      |> Burette.Number.number()
      |> Integer.to_string(16)
      |> String.pad_leading(6, "0")

    "\##{color_code}"
  end
end
