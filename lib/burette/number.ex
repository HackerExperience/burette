defmodule Burette.Number do
  @moduledoc """
  Generator for simple numeric data
  """

  @spec digits(pos_integer) :: String.t
  @doc """
  Produces a string composed only by numbers in the range 0..9 with length `length`
  """
  def digits(length)

  def digits(1) do
    0..9
    |> number()
    |> Integer.to_string()
  end
  def digits(length) when length > 1 and length < 256 do
    min = trunc(:math.pow(10, length - 1))
    max = trunc(:math.pow(10, length)) - 1

    min..max
    |> number()
    |> Integer.to_string()
  end
  def digits(length) when length > 255 do
    digits(255) <> digits(length - 255)
  end

  @lint {Credo.Check.Refactor.PipeChainStart, false}
  @spec number(Range.t) :: integer
  @doc """
  Produces an integer between `m` and `n`
  """
  def number(m..n) when m <= n do
    ((n - m + 1) * :rand.uniform() + m)
    |> Float.floor()
    |> trunc()
  end
  def number(n..m),
    do: number(m..n)

  @spec number(integer, integer) :: integer
  @doc """
  Alias for `number(min..max)`
  """
  def number(min, max),
    do: number(min..max)
end
