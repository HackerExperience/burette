defmodule Burette.Helper.Lexicon do

  defstruct [:lindex, :elements]

  def build(elements = [_|_]) do
    elements = List.to_tuple(elements)

    %__MODULE__{
      lindex: tuple_size(elements) - 1,
      elements: elements}
  end

  def take(%__MODULE__{elements: e, lindex: i}) do
    elem(e, Burette.Number.number(0..i))
  end

  def take(collection) do
    Enum.random(collection)
  end

  def merge(lexicon1, lexicon2) do
    %__MODULE__{elements: e1, lindex: l1} = lexicon1
    %__MODULE__{elements: e2, lindex: l2} = lexicon2

    # The smaller set should be the "base" so we traverse the minimum
    # amount of elements
    {complement, base} = l1 > l2 && {e1, e2} || {e2, e1}

    elements = Tuple.to_list(base) ++ Tuple.to_list(complement)
    new_lex = List.to_tuple(elements)

    %__MODULE__{
      lindex: tuple_size(new_lex) - 1,
      elements: new_lex}
  end

  def values(%__MODULE__{elements: e}),
    do: Tuple.to_list(e)
end
