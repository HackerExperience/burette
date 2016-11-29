defmodule Burette.Helper.Lexicon do

  defmodule Collection do
    defstruct elements: []

    def merge(c = %__MODULE__{elements: e}, lexicon),
      do: %__MODULE__{c| elements: [lexicon| e]}
    def merge(l1, l2),
      do: %__MODULE__{elements: [l1, l2]}

    def take(%__MODULE__{elements: e}),
      do: Enum.random(e)
  end

  defstruct [:lindex, :elements]

  def build(elements = [_|_]) do
    elements =
      elements
      |> Enum.with_index()
      |> Enum.map(fn {e, i} -> {i, e} end)
      |> :maps.from_list()

    %__MODULE__{
      lindex: map_size(elements) - 1,
      elements: elements}
  end

  def take(%__MODULE__{elements: e, lindex: i}) do
    Map.fetch!(e, Burette.Number.number(0..i))
  end

  def take(c = %Collection{}) do
    c
    |> Collection.take()
    |> take()
  end

  def take(collection) do
    Enum.random(collection)
  end

  def merge(lexicon1, lexicon2),
    do: Collection.merge(lexicon1, lexicon2)
end
