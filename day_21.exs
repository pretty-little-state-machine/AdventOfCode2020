Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  def part_1() do
    parse()

    forbidden =
      allergen_ingredients()
      |> Map.values()
      |> Enum.reduce(&MapSet.union/2)

    parse()
    |> Stream.map(&elem(&1, 0))
    |> Stream.concat()
    |> Enum.count(&(&1 not in forbidden))
  end

  def part_2() do
    input = allergen_ingredients()

    Enum.reduce_while(1..1_000, %{input: input, found: %{}}, fn x, outer_acc ->
      result =
        Enum.reduce(outer_acc.input, %{a: outer_acc.input, found: %{}}, fn {key, value}, acc ->
          if MapSet.size(value) == 1 do
            # Clean up map
            new_set =
              Map.drop(acc.a, [key])
              |> Enum.reduce(%{}, fn {key, new_set}, acc ->
                Map.put(acc, key, MapSet.difference(new_set, value))
              end)

            Map.put(acc, :a, new_set)
            |> Map.put(:found, Map.put(acc.found, value, key))
          else
            acc
          end
        end)

      outer_acc =
        Map.put(outer_acc, :found, Map.merge(outer_acc.found, Map.get(result, :found)))
        |> Map.put(:input, Map.get(result, :a))

      if %{} == result.a do
        {:halt, outer_acc.found}
      else
        {:cont, outer_acc}
      end
    end)
    |> Enum.sort_by(fn {_, v} -> v end)
    |> Enum.map(fn {mapset, _} -> Enum.at(mapset, 0) end)
    |> Enum.join(",")
    |> Z.debug()
  end

  defp parse() do
    Z.file_to_list("files/day_21_input.txt")
    |> Enum.map(fn line ->
      [i, a] = String.split(line, "(contains ")
      ingredients = String.split(i, " ") |> Enum.reject(fn x -> x == "" end)
      allergens = String.replace(a, ")", "") |> String.split(",") |> Enum.map(&String.trim(&1))

      {ingredients, allergens}
    end)
  end

  def allergen_ingredients do
    parse()
    |> Enum.map(&candidates/1)
    |> Enum.reduce(&merge/2)
  end

  def merge(c1, c2), do: Map.merge(c1, c2, fn _, s1, s2 -> MapSet.intersection(s1, s2) end)

  def candidates({ingredients, allergens}) do
    for allergen <- allergens, into: %{}, do: {allergen, MapSet.new(ingredients)}
  end
end

Advent.part_2()
# IO.puts("Part 1: #{Advent.part_1()}")
# Advent.part_2()
