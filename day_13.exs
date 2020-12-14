defmodule Advent do
  @max_runs 1_000_000

  def part_1(input) do
    {bus_time, bus_id} =
      Enum.reduce_while(1..@max_runs, input.time, fn _x, acc ->
        if Enum.any?(input.sched, fn x -> rem(acc, x) == 0 end) do
          bus_id = Enum.filter(input.sched, fn x -> rem(acc, x) == 0 end) |> List.first()
          {:halt, {acc, bus_id}}
        else
          {:cont, acc + 1}
        end
      end)

    (bus_time - input.time) * bus_id
  end

  @doc """
  modified from https://elixirforum.com/t/advent-of-code-2020-day-13/36180/5 - Defeated.
  """
  def part_2(input) do
    next_sequence(input)
  end

  def next_sequence(busses) do
    busses
    |> Enum.with_index()
    |> Enum.reduce({0, 1}, &add_to_sequence/2)
    |> elem(0)
  end

  defp add_to_sequence({"x", _index}, state), do: state

  defp add_to_sequence({bus, index}, {t, step}) do
    if Integer.mod(t + index, bus) == 0 do
      {t, lcm(step, bus)}
    else
      add_to_sequence({bus, index}, {t + step, step})
    end
  end

  defp lcm(a, b) do
    div(a * b, Integer.gcd(a, b))
  end

  def parse_input_part_1(input) do
    split =
      input
      |> String.replace("\r", "")
      |> String.split("\n")

    {wait, rest} = List.pop_at(split, 0)

    ids =
      rest
      |> List.first()
      |> String.split(",")
      |> Enum.filter(fn x -> x != "x" end)
      |> Enum.map(fn x -> String.to_integer(x) end)

    %{time: String.to_integer(wait), sched: ids}
  end

  def parse_input_part_2(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.at(1)
    |> String.split(",")
    |> Enum.map(fn x ->
      if "x" == x do
        x
      else
        String.to_integer(x)
      end
    end)
  end
end

{:ok, input} = File.read("./files/day_13_input.txt")
p1 = Advent.parse_input_part_1(input) |> Advent.part_1()
IO.puts("Part 1: #{p1}")

p2 = Advent.parse_input_part_2(input) |> Advent.part_2()
IO.puts("Part 2: #{p2}")
