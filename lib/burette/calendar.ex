defmodule Burette.Calendar do
  @moduledoc """
  Generator for dates and times
  """

  @typep erl_date :: {Calendar.year, Calendar.month, Calendar.day}
  @typep erl_time :: {Calendar.hour, Calendar.minute, Calendar.second}

  @spec date(Keyword.t) :: Date.t
  @doc """
  """
  def date(params \\ []) do
    {year, month, day} = make_date_tuple(params)

    {:ok, date} = Date.new(year, month, day)
    date
  end

  @spec time(Keyword.t) :: Time.t
  def time(params \\ []) do
    {hour, minute, second} = make_time_tuple(params)

    {:ok, time} = Time.new(hour, minute, second)
    time
  end

  @spec datetime(Keyword.t) :: DateTime.t
  def datetime(params \\ []) do
    date = make_date_tuple(params)
    time = make_time_tuple(params)

    erl_datetime_to_elx_datetime({date, time})
  end

  @spec future(Keyword.t) :: DateTime.t
  @doc """
  Generates a DateTime.t in the future

  NOTE: That datetime is returned as UTC

  You can pass to this function the same parameters you would pass to
  `datetime/1` but note that if you
  """
  def future(params \\ []),
    do: do_future(params)

  @spec past(Keyword.t) :: DateTime.t
  @doc """
  Works just like `future/1` but the date generated is in the past
  """
  def past(params \\ []),
    do: do_past(params)

  @spec do_past(Keyword.t, 0..25) :: DateTime.t
  defp do_past(params, retry_count \\ 0) do
    present = {{y, m, d}, {h, i, s}} = present_datetime()

    generate_date = &param_bubble_transform(&1, &2, &3, fn x -> maybe_random_number(x) end)

    generation_params = with \
      p = [{:year, ^y}| _] <- generate_date.(params, :year, y..(y - 20)),
      p = [{:month, ^m}| _] <- generate_date.(p, :month, m..1),
      p = [{:day, ^d}| _] <- generate_date.(p, :day, d..1),
      p = [{:hour, ^h}| _] <- generate_date.(p, :hour, h..0),
      p = [{:minute, ^i}| _] <- generate_date.(p, :minute, i..0),
      p = generate_date.(p, :second, max(s - 1, 0)..0)
    do
      p
    end

    past = {make_date_tuple(generation_params), make_time_tuple(generation_params)}

    present_u = :calendar.datetime_to_gregorian_seconds(present)
    past_u = :calendar.datetime_to_gregorian_seconds(past)

    if present_u >= past_u do
      erl_datetime_to_elx_datetime(past)
    else
      if 25 == retry_count do
        raise ArgumentError,
          message: """
          parameters provided to Burette.Calendar.past/1 make it impossible to provide a correct date in the past

          Last possible past date generated:
            #{inspect erl_datetime_to_elx_datetime(past)}
          Present date:
            #{inspect erl_datetime_to_elx_datetime(past)}
          Params:
            #{inspect params}
          """
      else
        do_past(params, retry_count + 1)
      end
    end
  end

  @spec do_future(Keyword.t, 0..25) :: DateTime.t
  defp do_future(params, retry_count \\ 0) do
    present = {{y, m, d}, {h, i, s}} = present_datetime()
    ldom = :calendar.last_day_of_the_month(y, m)

    generate_date = &param_bubble_transform(&1, &2, &3, fn x -> maybe_random_number(x) end)

    generation_params = with \
      p = [{:year, ^y}| _] <- generate_date.(params, :year, y..(y + 20)),
      p = [{:month, ^m}| _] <- generate_date.(p, :month, m..12),
      p = [{:day, ^d}| _] <- generate_date.(p, :day, d..ldom),
      p = [{:hour, ^h}| _] <- generate_date.(p, :hour, h..23),
      p = [{:minute, ^i}| _] <- generate_date.(p, :minute, i..59),
      p = generate_date.(p, :second, min(s + 1, 59)..59)
    do
      p
    end

    future = {make_date_tuple(generation_params), make_time_tuple(generation_params)}

    present_u = :calendar.datetime_to_gregorian_seconds(present)
    future_u = :calendar.datetime_to_gregorian_seconds(future)

    if present_u <= future_u do
      erl_datetime_to_elx_datetime(future)
    else
      if 25 == retry_count do
        raise ArgumentError,
          message: """
          parameters provided to Burette.Calendar.future/1 make it impossible to provide a correct date in the future

          Last possible future date generated:
            #{inspect erl_datetime_to_elx_datetime(future)}
          Present date:
            #{inspect erl_datetime_to_elx_datetime(present)}
          Params:
            #{inspect params}
          """
      else
        do_future(params, retry_count + 1)
      end
    end
  end

  @spec make_date_tuple(Keyword.t) :: erl_date
  defp make_date_tuple(params) do
    year =
      params
      |> Keyword.get(:year, 1950..2050)
      |> maybe_random_number()

    month =
      params
      |> Keyword.get(:month, 1..12)
      |> maybe_random_number()

    ldom = :calendar.last_day_of_the_month(year, month)
    dp = Keyword.get(params, :day, 1..ldom)

    day = maybe_random_number(is_integer(dp) && dp > ldom && ldom || dp)

    {year, month, day}
  end

  @spec make_time_tuple(Keyword.t) :: erl_time
  defp make_time_tuple(params) do
    hour =
      params
      |> Keyword.get(:hour, 0..23)
      |> maybe_random_number()

    minute =
      params
      |> Keyword.get(:minute, 0..59)
      |> maybe_random_number()

    # Ignore leap seconds
    second =
      params
      |> Keyword.get(:second, 0..59)
      |> maybe_random_number()

    {hour, minute, second}
  end

  @spec erl_datetime_to_elx_datetime({erl_date, erl_time}) :: DateTime.t
  defp erl_datetime_to_elx_datetime(erl_datetime) do
    erl_datetime
    |> :calendar.datetime_to_gregorian_seconds()
    |> Kernel.-(62_167_219_200) # EPOCH in seconds
    |> DateTime.from_unix!()
  end

  @spec present_datetime() :: {erl_date, erl_time}
  defp present_datetime do
    :calendar.local_time()
    |> :calendar.local_time_to_universal_time_dst()
    |> case do
      [datetime_utc] ->
        datetime_utc
      [_dst, datetime_utc] ->
        # This happens on a local time that is switching from dst. At that
        # moment, there are two possible different utc datetimes.
        # To avoid bugs, the library will prefer the one from future
        datetime_utc
    end
  end

  @spec maybe_random_number(Range.t | integer) :: integer
  defp maybe_random_number(m..n),
    do: Burette.Number.number(m..n)
  defp maybe_random_number(v) when is_integer(v),
    do: v

  @spec param_bubble_transform(Keyword.t, atom, term, ((term) -> term)) :: Keyword.t
  defp param_bubble_transform(keywords, key, default, fun) do
    keywords
    |> Keyword.put_new(key, default)
    |> pop_update(key, fun)
  end

  @spec pop_update(Keyword.t, atom, term, ((term) -> term)) :: Keyword.t
  defp pop_update(keywords, key, fun, acc \\ [])
  defp pop_update([{k, v}| t], k, fun, acc),
    do: [{k, fun.(v)}| :lists.reverse(acc)] ++ t
  defp pop_update([h| t], k, fun, acc),
    do: pop_update(t, k, fun, [h| acc])
  defp pop_update([], _, _, acc),
    do: :lists.reverse(acc)
end
