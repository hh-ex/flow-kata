defmodule FlowKata do
  @filename "demo_set.csv"

  @doc """
  Returns a flow that reads from #{@filename}, parses the CSV table into a
  stream of events where each element has this structure:

      {city_name::binary, temperature::float}

  """
  def get_flow do
    @filename
    # Open a stream that contains file contents, line by line
    |> File.stream!([:read], :line)
    # Use the csv library to decode csv contents; basically, it maps
    # "City,Temperature" to [City, Temperature]
    # Also returns a stream
    |> CSV.decode!()
    # Pipe the stream into a flow
    |> Flow.from_enumerable()
    # Further decode the data from the input file.
    |> Flow.map(fn [city, temperature] -> {city, String.to_float(temperature)} end)
  end

  @doc """
  Returns a list with all city names found in the given flow, sorted alphabetically
  """
  def city_names(flow) do
    flow
    # Map the data tuple to the city name
    |> Flow.map(fn {city, _t} -> city end)
    # Repartition our flow so that cities with the same first letter end up in the same partition
    |> Flow.partition(key: fn << first::binary-size(1), _rest::binary>> -> first end)
    # Like Enum.uniq, but once per partition
    |> Flow.uniq()
    # Use Enum at the end to actually execute the flow
    |> Enum.sort()
  end

  @doc """
  Returns the average temperature across all records of the given flow
  """
  def average(flow) do
    {sum, count} =
      flow
      # Reduce the data tuples to tuples that have the sum and the count
      |> Flow.reduce(fn -> {0, 0} end,
                     fn {_, a}, {sum, count} -> {sum + a, count + 1} end)
      # Tell Flow.reduce to use the last accumulator as events
      |> Flow.emit(:state)
      # Use Enum.reduce to sum the {sum, count} tuples from the different partitions into one.
      # Again, we use an Enum function at the end to actually execute the flow.
      |> Enum.reduce({0, 0}, fn {sum_a, count_a}, {sum, count} -> {sum_a + sum, count_a + count} end)
    sum / count
  end

  @doc """
  Returns the average temperature per city of the given flow
  """
  def average_by_city(flow) do
    flow
    # Repartition the flow so that no city is processed in more than one partition
    # {:elem, 0} tells Flow to use the first item in the data tuple
    |> Flow.partition(key: {:elem, 0})
    # Reduce the data tuples in each partition into a map of the structure
    # %{city_name::binary => %{sum::integer, count::integer}}
    |> Flow.reduce(fn -> %{} end, fn {city, t}, map ->
      Map.update(map, city, %{}, fn city_map ->
        city_map
        |> Map.update(:sum, 0, &(&1 + t))
        |> Map.update(:count, 0, &(&1 + 1))
      end)
    end)
    # Tell Flow.reduce to emit the map as events, this will convert it to a keyword list
    |> Flow.emit(:events)
    # Collect the flow into a map, while mapping the contents into simple tuples {city_name, avg}
    # so the resulting maps looks like %{city_name => average}
    |> Enum.into(%{}, fn
      {city, %{sum: sum, count: count}} -> {city, sum / count}
    end)
  end
end
