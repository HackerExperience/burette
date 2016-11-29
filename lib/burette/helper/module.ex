defmodule Burette.Helper.Module do

  def to_module(prefix, locale) do
    m =
      locale
      |> String.split("_")
      |> Enum.map(&String.capitalize/1)
      |> Enum.join(".")

    Module.concat(prefix, m)
  end
end
