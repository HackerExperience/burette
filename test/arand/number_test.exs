defmodule Arand.NumberTest do

  use ExUnit.Case, async: true
  use ExCheck

  alias Arand.Number

  describe "digits/1" do
    property "digits length" do
      for_all length in such_that(x in int when x > 0) do
        (length |> Number.digits() |> String.length()) === length
      end
    end

    property "digits datatype" do
      for_all length in such_that(x in int when x > 0) do
        is_binary(Number.digits(length))
      end
    end

    property "digits content" do
      for_all length in such_that(x in int when x > 0 and x < 50) do
        length
        |> Number.digits()
        |> String.graphemes()
        |> Enum.all?(&(&1 in ~w/0 1 2 3 4 5 6 7 8 9/))
      end
    end
  end

  describe "number/1" do
    @tag iterations: 5_000
    property "number range" do
      for_all {x, y} in such_that({xx, yy} in {int, int} when xx < yy) do
        val = Number.number(x..y)
        x <= val and val <= y
      end
    end

    property "number datatype" do
      for_all {x, y} in such_that({xx, yy} in {int, int} when xx < yy) do
        is_integer(Number.number(x..y))
      end
    end
  end
end
