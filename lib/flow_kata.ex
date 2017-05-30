defmodule FlowKata do
  @filename "demo_set.csv"

  @doc """
  Returns a flow that reads from #{@filename}, parses the CSV table into a
  stream of events where each element has this structure:

      {city_name::binary, temperature::float}

  """
  def get_flow do
    @filename
    # open file stream
    # decode with CSV.decode!
    # create a flow from the stream
    # map over each event to parse the data
  end

  @doc """
  Returns a list with all city names found in the given flow, sorted alphabetically
  """
  def city_names(flow) do
    # map to just the city name
    # partition by first letter
    # Flow.uniq
    # Enum.sort
  end

  @doc """
  Returns the average temperature across all records of the given flow
  """
  def average(flow) do
    # reduce to {sum, count}
    # don't forget to call Flow.emit(:state)
    # reduce again to a single {sum, count} tuple with Enum
    # calculate the average and return it
  end

  @doc """
  Returns the average temperature per city of the given flow
  """
  def average_by_city(flow) do
    # partition by city name
    # reduce to a map %{city_name => %{sum: sum, count: count}}
    # don't forget to call Flow.emit(:events)
    # Enum.map the events to calculate the average
    # Collect into a map
  end
end
