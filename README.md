# Flow Kata

This kata is an introduction to flow and covers:

 * Creating a flow from a data source
 * The importance of partitions
 * Map and reduce functions and how they behave differently from the `Enum` or `Stream` variants

## How to solve the kata

Implement the functions in `lib/flow_kata.ex`.

To test if you're doing the right thing, run `mix test`.

You can test your implementations individually:

 * `get_flow`: `mix test test/flow_kata_test.exs:9`
 * `city_names`: `mix test test/flow_kata_test.exs:23`
 * `average`: `mix test test/flow_kata_test.exs:28`
 * `average_by_city`: `mix test test/flow_kata_test.exs:32`

## If you need help

This repository contains 3 branches:

 * `master`: skeleton where you have to write the implementation
 * `tips`: skeleton with tips inside the function bodies
 * `solution`: complete solution with explanatory comments
