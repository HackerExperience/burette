defmodule Burette.Helper.Lexicon do

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

  def take(collection) do
    Enum.random(collection)
  end

  def merge(lexicon1, lexicon2) do
    %__MODULE__{elements: e1, lindex: l1} = lexicon1
    %__MODULE__{elements: e2, lindex: l2} = lexicon2

    # The smaller set should be the "complement" so we traverse the minimum
    # amount of elements
    {base, complement, i} = l1 > l2 && {e1, e2, l1 + 1} || {e2, e1, l2 + 1}

    new_lex =
      complement
      |> Enum.map(fn {k, v} -> {k + i, v} end)
      |> Enum.into(base)

    %__MODULE__{
      lindex: map_size(new_lex) - 1,
      elements: new_lex}
  end

  def values(%__MODULE__{elements: e}),
    do: Map.values(e)
end
