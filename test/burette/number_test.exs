defmodule Burette.NumberTest do

  use ExUnit.Case, async: true

  defp generate(times, range_rules) do
    for _ <- 1..times do
      range_rules
      |> List.wrap()
      |> Enum.map(&Burette.Number.number/1)
      |> case do
        [el] ->
          el
        el = [_|_] ->
          List.to_tuple(el)
      end
    end
  end

  describe "digits/1" do
    test "length" do
      100
      |> generate(1..32)
      |> Enum.each(fn length ->
        digits = Burette.Number.digits(length)

        assert length === String.length(digits)
      end)
    end

    test "content" do
      100
      |> generate(1..100)
      |> Enum.each(fn length ->
        graphemes =
          length
          |> Burette.Number.digits()
          |> String.graphemes()

        assert Enum.all?(graphemes, &(&1 in ~w/0 1 2 3 4 5 6 7 8 9/))
      end)
    end

    test "very long digits works" do
      length = 65_536

      digits = Burette.Number.digits(length)

      assert is_binary(digits)
      assert length === String.length(digits)
    end
  end

  describe "number/1" do
    @tag iterations: 5_000
    test "generated numbers are inside range" do
      5_000
      |> generate([-10..0, 0..10])
      |> Enum.each(fn {m, n} ->
        val = Burette.Number.number(m..n)

        assert val in m..n
      end)
    end

    test "generated numbers are integers" do
      5_000
      |> generate([-16777216..0, 0..16777216])
      |> Enum.each(fn {m, n} ->
        assert is_integer(Burette.Number.number(m..n))
      end)
    end

    test "range values order doesn't match" do
      val = Burette.Number.number(100..-100)

      assert is_integer(val)
      assert val in -100..100
    end
  end
end
