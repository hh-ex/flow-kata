defmodule FlowKata do
  @filename "demo_set.csv"

  @doc """
  Returns a flow that reads from #{@filename}, parses the CSV table into a
  stream of events where each element has this structure:

      {city_name::binary, temperature::float}

  """
  def get_flow do

  end

  @doc """
  Returns a list with all city names found in the given flow, sorted alphabetically
  """
  def city_names(flow) do

  end

  @doc """
  Returns the average temperature across all records of the given flow
  """
  def average(flow) do

  end

  @doc """
  Returns the average temperature per city of the given flow
  """
  def average_by_city(flow) do

  end
end
