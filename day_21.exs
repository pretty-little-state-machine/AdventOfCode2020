Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  def part_1() do
    parse("files/day_21_input.txt")
  end

  defp parse(file) do
    foods =
      Z.file_to_list(file)
      |> Enum.map(fn line ->
        [i, a] = String.split(line, "(contains ")
        ingredients = String.split(i, " ") |> Enum.reject(fn x -> x == "" end)
        allergens = String.replace(a, ")", "") |> String.split(",") |> Enum.map(&String.trim(&1))

        %{ingredients: ingredients, allergens: allergens}
      end)

    foods |> make_allergen_potentials()

    # foods |> ingredient_frequencies()
  end

  @doc """
  Makes a list of potential allergens for each item.
  """
  def make_allergen_potentials(foods) do
    Enum.reduce(foods, [], fn f, f_acc ->
      perms =
        Z.permutations([f.ingredients, f.allergens])
        |> Enum.reduce(%{}, fn p, acc ->
          [ingredient, allergen] = p
          value = Map.get(acc, ingredient, []) ++ [allergen]
          Map.put(acc, ingredient, value)
        end)

      f_acc ++ [perms]
    end)
    |> Z.debug()
  end

  def ingredient_frequencies(foods) do
    ingredients =
      Enum.reduce(foods, [], fn x, acc ->
        acc ++ x.ingredients
      end)
      |> Enum.frequencies()
      |> Z.debug()
  end
end

Advent.part_1()
# IO.puts("Part 1: #{Advent.part_1()}")
# Advent.part_2()
