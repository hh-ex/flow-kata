defmodule FlowKata do
  @filename "demo_set.csv"

  @doc """
  Returns a flow that reads from #{@filename}, parses the CSV table into a
  list where each element has this structure:

      {city_name::binary, temperature::float}

  """
  def get_flow do
    @filename
    |> File.stream!([:read], :line)
    |> CSV.decode!()
    |> Flow.from_enumerable()
    |> Flow.map(fn [city, temperature] -> {city, String.to_float(temperature)} end)
  end

  @doc """
  Returns a list with all city names found in the given flow, sorted alphabetically
  """
  def city_names(flow) do
    flow
    |> Flow.map(fn {city, _t} -> city end)
    |> Flow.partition(key: fn << first::binary-size(1), _rest::binary>> -> first end)
    |> Flow.uniq()
    |> Enum.sort()
  end

  @doc """
  Returns the average temperature across all records of the given flow
  """
  def average(flow) do
    {sum, count} =
      flow
      |> Flow.reduce(fn -> {0, 0} end,
                     fn {_, a}, {sum, count} -> {sum + a, count + 1} end)
      |> Flow.emit(:state)
      |> Enum.reduce({0, 0}, fn {sum_a, count_a}, {sum, count} -> {sum_a + sum, count_a + count} end)
    sum / count
  end

  @doc """
  Returns the average temperature per city of the given flow
  """
  def average_by_city(flow) do
    flow
    |> Flow.partition(key: {:elem, 0})
    |> Flow.reduce(fn -> %{} end, fn {city, t}, map ->
      Map.update(map, city, %{}, fn city_map ->
        city_map
        |> Map.update(:sum, 0, &(&1 + t))
        |> Map.update(:count, 0, &(&1 + 1))
      end)
    end)
    |> Flow.emit(:events)
    |> Enum.into(%{}, fn
      {city, %{sum: sum, count: count}} -> {city, sum / count}
    end)
  end
end
