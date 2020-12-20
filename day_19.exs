Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  def part_1() do
    [raw_input, regex] = parse_input("files/day_19_input.txt")

    raw_input
    |> Enum.reduce(0, fn x, acc ->
      acc + if Regex.match?(regex, x), do: 1, else: 0
    end)
  end

  def parse_input(file) do
    [raw_rules, raw_input] = Z.file_to_list(file) |> Z.chunk_filter_values("")

    regex = parse_rules(raw_rules) |> build()
    [raw_input, regex]
  end

  # End case for build, clean it and pop into a regex sigil with ^/$
  def build(rules) when map_size(rules) == 1 do
    r = rules |> Map.get("0") |> String.replace(" ", "")
    ~r/^#{r}$/
  end

  def build(rules) do
    # Extract map entries that do NOT have digits in them as replacements
    letters =
      Enum.reject(rules, fn {_, v} -> Regex.match?(~r{\d}, v) end)
      |> Z.tuple_to_map()

    # Replace digits with the keys (letters above)
    new_rules =
      Enum.reduce(rules, %{}, fn {rk, rv}, ra ->
        nv =
          Enum.reduce(letters, rv, fn {lk, lv}, la ->
            String.replace(la, " #{lk} ", " #{lv} ")
            |> String.replace(" #{lk} ", " #{lv} ")
          end)

        Map.put(ra, rk, nv)
      end)
      # Drop the keys for the letters, this will shrink until only key "0" is left.
      |> Map.drop(Map.keys(letters))

    build(new_rules)
  end

  defp parse_rules(input) do
    rule_names = Enum.map(input, fn r -> String.split(r, ":") |> List.first() end)

    rule_parts =
      Enum.map(input, fn r ->
        s =
          String.replace(r, "\"", "")
          |> String.split(":")
          |> Enum.at(1)
          |> String.split(" ")
          |> List.delete_at(0)
          |> Enum.join(" ")
          |> String.replace(",|,", ")|(")

        "( #{s} )"
      end)

    Enum.zip(rule_names, rule_parts)
    |> Enum.reduce(%{}, fn {n, r}, acc -> Map.put(acc, n, "(#{r})") end)
  end
end

IO.puts("Part 1: #{Advent.part_1()}")
