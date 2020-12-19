Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  @r ~r/(\((?>[^()]+|(?1))*\))/
  @max_depth 20

  # Public Interface
  def part_1() do
    problems =
      parse_input("files/day_18_input.txt")
      |> Enum.map(fn x -> String.replace(x, " ", "") end)

    Enum.reduce(problems, 0, fn x, acc ->
      p = make_map(x, %{x => nil})

      result =
        Enum.reduce(1..@max_depth, p, fn _, acc ->
          solve(acc)
        end)

      acc + result
    end)
  end

  # Any runs after last run
  def solve(input) when is_integer(input), do: input

  # Last Run
  def solve(map) when map_size(map) == 1 do
    Enum.reduce(map, 0, fn {k, _}, _ ->
      {nums, ops} = string_to_rpn(k)
      {start, list} = List.pop_at(nums, 0)
      rpn(list, ops, start)
    end)
  end

  def solve(map) do
    # Derive solutions for partial operations
    partial =
      Enum.reject(map, fn {_, v} -> v != nil end)
      |> Enum.reject(fn {k, _} -> String.contains?(k, ")") end)
      |> Enum.reduce(%{}, fn {k, _}, acc ->
        {nums, ops} = string_to_rpn(k)
        {start, list} = List.pop_at(nums, 0)

        Map.put(acc, k, rpn(list, ops, start))
      end)

    # Replace solved partials into original map
    Enum.reduce(map, %{}, fn {k, v}, acc ->
      new_key =
        Enum.reduce(partial, k, fn {pk, pv}, acc ->
          String.replace(acc, "(#{pk})", "#{pv}")
        end)

      Map.put(acc, new_key, v)
    end)
    |> Map.drop(Map.keys(partial))
  end

  def string_to_rpn(string) do
    g =
      String.graphemes(string)
      |> Enum.chunk_by(fn x -> x == "+" or x == "*" end)
      |> Enum.map(fn x -> Enum.join(x) end)

    nums = g |> Enum.take_every(2) |> Enum.map(fn x -> String.to_integer(x) end)
    ops = g |> List.delete_at(0) |> Enum.take_every(2)

    {nums, ops}
  end

  def rpn([], [], stack), do: stack

  def rpn(nums, ops, stack) do
    {x, lx} = List.pop_at(nums, 0)
    {o, lo} = List.pop_at(ops, 0)
    stack = op(stack, x, o)

    rpn(lx, lo, stack)
  end

  def op(a, b, "+"), do: a + b
  def op(a, b, "*"), do: a * b
  def op(a, _, nil), do: a

  def make_map(input, acc) do
    blocks = Regex.scan(@r, input)

    Enum.reduce(blocks, acc, fn b, b_acc ->
      v = b |> List.first() |> pop_parens()
      Map.put(b_acc, v, nil)
      Map.merge(b_acc, make_map(v, %{v => nil}))
    end)
  end

  defp pop_parens(string) do
    string
    |> String.replace_prefix("(", "")
    |> String.replace_suffix(")", "")
  end

  def parse_input(file) do
    Z.file_to_list(file)
  end
end

# Advent.part_1()
IO.puts("Part 1: #{Advent.part_1()}")
# IO.puts("Part 2: #{Advent.part_2()}")
