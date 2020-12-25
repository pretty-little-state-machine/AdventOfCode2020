defmodule Cups do
  @doc """
  A circular map simualating a linked-list with a cursor.
  """
  def instatiate(list) do
    build_map(%{}, list)
    # Sitch the last key to the first value - making it circular
    |> Map.put(Enum.at(list, Kernel.length(list) - 1), Enum.at(list, 0))
    # Build a cursor
    |> Map.put(:cursor, Enum.at(list, 0))
  end

  @doc """
  Should be O(log n) for every map operation.
  """
  def take(cups) do
    first = Map.get(cups, cups.cursor)
    second = Map.get(cups, first)
    third = Map.get(cups, second)
    fourth = Map.get(cups, third)
    # Stich up the circle (the old ones are still in it though)
    {Map.put(cups, cups.cursor, fourth), [first, second, third]}
  end

  def stich(cups, destination, first_splice, last_splice) do
    splice_endpoint = Map.get(cups, destination)

    cups
    |> Map.put(destination, first_splice)
    |> Map.put(last_splice, splice_endpoint)
  end

  def update_cursor(cups), do: Map.put(cups, :cursor, Map.get(cups, cups.cursor))
  def set_cursor(cups, cursor), do: Map.put(cups, :cursor, cursor)

  def print(cups) do
    IO.write("(#{cups.cursor}) ")
    print(cups, cups.cursor)
    IO.puts("")
    cups
  end

  defp print(cups, last_value) do
    value = Map.get(cups, last_value)

    if cups.cursor != value do
      IO.write("#{value} ")
      print(cups, value)
    end
  end

  # Private Helpers
  defp build_map(map, []), do: map

  defp build_map(map, list) do
    {key, rest} = List.pop_at(list, 0)
    build_map(Map.put(map, key, List.first(rest)), rest)
  end
end

defmodule Advent do
  def part_1() do
    cups = Cups.instatiate([2, 1, 9, 3, 4, 7, 8, 6, 5])

    Enum.reduce(1..100, cups, fn _, acc -> run_cycle(acc, 9, 9) end)
    |> Cups.set_cursor(1)
    |> Cups.print()
  end

  def part_2() do
    starting = [2, 1, 9, 3, 4, 7, 8, 6, 5]
    more_cups = Enum.to_list(10..1_000_000)
    cups = Cups.instatiate(starting ++ more_cups)

    cups =
      Enum.reduce(1..10_000_000, cups, fn _, acc ->
        run_cycle(acc, 1_000_000, 1_000_000)
      end)
      |> Cups.set_cursor(1)

    first = Map.get(cups, cups.cursor)
    second = Map.get(cups, first)
    first * second
  end

  def run_cycle(cups, circle_size, max_cup) do
    {cups, taken} = Cups.take(cups)

    destination =
      Enum.reduce_while(1..circle_size, cups.cursor - 1, fn _, acc ->
        d = if acc < 1, do: max_cup, else: acc
        if d in taken, do: {:cont, d - 1}, else: {:halt, d}
      end)

    cups
    |> Cups.stich(destination, Enum.at(taken, 0), Enum.at(taken, 2))
    |> Cups.update_cursor()
  end
end

Advent.part_1()
IO.puts("Part 2: #{Advent.part_2()}")
