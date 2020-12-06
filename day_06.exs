defmodule Advent do
  def part_1(input) do
    input
    |> parse_groups()
    |> Enum.map(fn x -> x |> get_filtered_frequencies() |> count_keys_in_map() end)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  def part_2(input) do
    input
    |> parse_groups()
    |> Enum.map(fn x -> count_persons_and_frequencies(x) end)
    |> Enum.map(fn x ->
      shared_answers =
        x.f
        |> Enum.reject(fn {_, v} -> v != x.p end)
        |> Map.new()
        |> count_keys_in_map()
    end)
    |> Enum.reduce(fn x, acc -> x + acc end)
  end

  defp parse_groups(input) do
    input
    |> String.split("\n\n")
  end

  defp count_keys_in_map(map) do
    map
    |> Enum.map(fn {_, v} -> v end)
    |> Enum.count()
  end

  defp count_persons_and_frequencies(input) do
    persons =
      input
      |> String.graphemes()
      |> Enum.count(&(&1 == "\n"))

    %{p: persons + 1, f: get_filtered_frequencies(input)}
  end

  defp get_filtered_frequencies(input) do
    input
    |> String.replace("\n", "")
    |> String.graphemes()
    |> Enum.frequencies()
  end
end

{:ok, input} = File.read("./files/day_06_input.txt")
part_1 = Advent.part_1(input)
part_2 = Advent.part_2(input)

IO.puts("Part 1: #{part_1}")
IO.puts("Part 2: #{part_2}")
