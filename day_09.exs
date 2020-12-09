defmodule Advent do
  def part_1(input) do
    {first_invalid, _} =
      parse_input(input)
      |> validate_numbers(25)
      |> Enum.filter(fn {_, valid} -> valid == false end)
      |> List.first()

    first_invalid
  end

  def part_2(input, num_to_find, max_contig) do
    values = parse_input(input) |> Enum.filter(fn x -> x < num_to_find end)

    Enum.map(max_contig..2, fn x ->
      sliding_sum(num_to_find, values, x)
    end)
    |> Enum.filter(fn x -> x != nil end)
    |> List.first()
  end

  # Part 1 Helpers
  defp validate_numbers(values, range) do
    for {x, idx} <- Enum.slice(values, range, Kernel.length(values)) |> Enum.with_index() do
      sums = build_sums_table(Enum.slice(values, idx, range))
      {x, Enum.member?(sums, x)}
    end
  end

  defp build_sums_table(values) do
    for(i <- values, j <- values, into: [], do: i + j)
    |> Enum.drop_every(Kernel.length(values) + 1)
  end

  # Part 2 Helpers
  defp sliding_sum(num_to_find, values, range) do
    for {_, idx} <- Enum.slice(values, range, Kernel.length(values)) |> Enum.with_index() do
      slice = Enum.slice(values, idx, range)
      sums = Enum.sum(slice)
      {sums, slice}
    end
    |> Enum.filter(fn {x, _} -> x == num_to_find end)
    |> sum_min_max()
  end

  defp sum_min_max([]), do: nil

  defp sum_min_max(list) do
    {_, vals} = List.first(list)
    {min, max} = Enum.min_max(vals)
    min + max
  end

  # File Input
  defp parse_input(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
end

{:ok, input} = File.read("./files/day_09_input.txt")
part_1 = Advent.part_1(input)
IO.puts("Part 1: #{part_1}")

part_2 = Advent.part_2(input, part_1, 20)
IO.puts("Part 2: #{part_2}")
