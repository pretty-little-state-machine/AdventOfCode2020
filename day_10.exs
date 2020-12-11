defmodule Advent do
  def part_1(input) do
    diffs =
      get_diffs(input)
      |> Enum.frequencies()

    diffs[1] * diffs[3]
  end

  def part_2(input) do
    contigs =
      get_diffs(input)
      |> Enum.chunk_by(fn x -> x == 3 end)
      |> Enum.filter(fn x -> 3 not in x end)
      |> Enum.map(fn x -> Kernel.length(x) end)

    possibilities =
      for v <- contigs do
        floor((v - 1) * v / 2 + 1)
      end
      |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  defp get_diffs(input) do
    adapters =
      input
      |> parse_input()
      |> Enum.sort()

    adapters = [0 | adapters]
    adapters = adapters ++ [Enum.max(adapters) + 3]
    slice = Enum.slice(Enum.with_index(adapters), 1..Kernel.length(adapters))

    for {a, idx} <- slice do
      a - Enum.at(adapters, idx - 1)
    end
  end

  # File Input
  defp parse_input(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
end

{:ok, input} = File.read("./files/day_10_input.txt")
part_1 = Advent.part_1(input)
IO.puts("Part 1: #{part_1}")

part_2 = Advent.part_2(input)
IO.puts("Part 2: #{part_2}")
