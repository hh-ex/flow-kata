defmodule FlowKataTest do
  use ExUnit.Case, async: true
  doctest FlowKata

  setup_all _context do
    [flow: FlowKata.get_flow()]
  end

  test "get_flow", context do
    flow = context[:flow]

    assert %Flow{} = flow

    count = Enum.count(flow)

    assert [{city, temperature}] = Enum.take(flow, 1)
    assert is_binary(city)
    assert is_number(temperature)

    assert count == 93984
  end

  test "city_names", context do
    assert FlowKata.city_names(context[:flow]) == ["Berlin", "Bremen", "Dresden", "Düsseldorf", "Frankfurt", "Hamburg", "Kassel",
 "Köln", "Leipzig", "München", "Wiesbaden"]
  end

  test "average", context do
    assert FlowKata.average(context[:flow]) |> Float.round(5) == 9.94401
  end

  test "average_by_city", context do
    assert FlowKata.average_by_city(context[:flow]) == %{"Berlin" => 9.86881966633455, "Bremen" => 10.00483547683158,
  "Dresden" => 10.03998714525443, "Düsseldorf" => 10.148992587842331,
  "Frankfurt" => 9.768089992872216, "Hamburg" => 10.062923416574893,
  "Kassel" => 9.393157445500535, "Köln" => 10.009526773579836,
  "Leipzig" => 10.022572595642517, "München" => 10.110183205900496,
  "Wiesbaden" => 9.960503686533086}
  end
end
