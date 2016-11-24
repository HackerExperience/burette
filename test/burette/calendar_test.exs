defmodule Burette.CalendarTest do

  use ExUnit.Case, async: true
  use ExCheck

  describe "past" do
    test "generates datetimes in the past" do
      dates = Enum.map(1..5_000, fn _ -> Burette.Calendar.past() end)
      now = DateTime.utc_now() |> DateTime.to_unix()

      dates_set = MapSet.new(dates)

      Enum.each(dates, fn date ->
        assert %DateTime{} = date
        date_u = DateTime.to_unix(date)

        assert date_u < now
      end)

      assert MapSet.size(dates_set) in 4_500..5_000
    end

    test "retries when date is not in the past" do
      Enum.each(1..3_000, fn _ ->
        now = DateTime.utc_now()
        opts = [year: now.year, month: now.month, day: now.day, hour: now.hour, minute: now.minute]

        # The only random data is the second as we specified everything else.
        # There is atleast 1 in 60 chances of colision. As we are runing 3_000
        # tests it is certain that collisions will happen. The test succedding
        # means by inference that, on collision, the generator module will retry
        assert %DateTime{} = Burette.Calendar.past(opts)
      end)
    end

    test "raise if params make it impossible to generate a date in the past" do
      assert_raise ArgumentError, fn ->
        # TODO: Fix this when the right time comes
        Burette.Calendar.past(year: 2020)
      end
    end
  end

  describe "future" do
    test "generates datetimes in the future" do
      dates = Enum.map(1..5_000, fn _ -> Burette.Calendar.future() end)
      now = DateTime.utc_now() |> DateTime.to_unix()

      dates_set = MapSet.new(dates)

      Enum.each(dates, fn date ->
        assert %DateTime{} = date
        date_u = DateTime.to_unix(date)

        assert date_u > now
      end)

      assert MapSet.size(dates_set) in 4_500..5_000
    end

    test "retries when date is not in the future" do
      Enum.each(1..3_000, fn _ ->
        now = DateTime.utc_now()
        opts = [year: now.year, month: now.month, day: now.day, hour: now.hour, minute: now.minute]

        # The only random data is the second as we specified everything else.
        # There is atleast 1 in 60 chances of colision. As we are runing 3_000
        # tests it is certain that collisions will happen. The test succedding
        # means by inference that, on collision, the generator module will retry
        assert %DateTime{} = Burette.Calendar.future(opts)
      end)
    end

    test "raise if params make it impossible to generate a date in the future" do
      assert_raise ArgumentError, fn ->
        # Welp, shall we build a time machine this code should work, right?
        Burette.Calendar.future(year: 1990)
      end
    end
  end

  describe "date" do
    property "date - generation" do
      for_all \
        {year, month, day, drop} in such_that(
          {_, _, _, d} in {int(1900, 2100), int(1, 12), int(1, 28), int(3)}
          when d >= 0 and d <= 3)
      do
        date =
          [year: year, month: month, day: day]
          |> Enum.sort_by(fn _ -> Burette.Number.number(1..10) end)
          |> Enum.drop(drop)
          |> Burette.Calendar.date()

        match?(%Date{}, date)
      end
    end

    property "date - day fallbacks to last day of month" do
      for_all day in such_that(x in int when x >= 1 and x <= 31) do
        match?(%Date{}, Burette.Calendar.date(day: day))
      end
    end

    test "generates valid random dates" do
      dates = Enum.map(1..5_000, fn _ -> Burette.Calendar.date() end)
      dates_set = MapSet.new(dates)

      Enum.each(dates, &(assert %Date{} = &1))
      assert MapSet.size(dates_set) in 4_500..5_000
    end
  end

  describe "time" do
    property "time - valid dates" do
      for_all \
        {hour, minute, second, drop} in such_that(
          {_, _, _, d} in {int(0, 23), int(0, 59), int(0, 59), int(3)}
          when d >= 0 and d <= 3)
      do
        time =
          [hour: hour, minute: minute, second: second]
          |> Enum.sort_by(fn _ -> Burette.Number.number(1..10) end)
          |> Enum.drop(drop)
          |> Burette.Calendar.time()

        match?(%Time{}, time)
      end
    end

    test "generates valid random times" do
      times = Enum.map(1..5_000, fn _ -> Burette.Calendar.time() end)
      times_set = MapSet.new(times)

      Enum.each(times, &(assert %Time{} = &1))
      assert MapSet.size(times_set) in 4_500..5_000
    end
  end
end
