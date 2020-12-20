Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  def part_1() do
    [raw_rules, raw_input] = Z.file_to_list("files/day_19_input.txt") |> Z.chunk_filter_values("")

    regex = parse_rules(raw_rules) |> build()

    raw_input
    |> Enum.reduce(%{}, fn x, acc ->
      Map.put(acc, x, Regex.match?(regex, x))
    end)
    |> Enum.filter(fn {_, v} -> v == true end)
    |> Enum.count()
    |> Z.debug()
  end

  def part_2() do
    [raw_rules, raw_input] = Z.file_to_list("files/day_19_input.txt") |> Z.chunk_filter_values("")

    regex =
      raw_rules
      |> parse_rules()
      |> Map.put(8, "(( 42 | 42 8 ))")
      |> Map.put(11, "(( 42 31 | 42 11 31 ))")
      |> build()

    raw_input
    |> Enum.reduce(%{}, fn x, acc ->
      case :re2.run(x, regex) do
        {:match, _} -> Map.put(acc, x, true)
        :nomatch -> acc
      end
    end)
    |> Enum.count()
    |> Z.debug()
  end

  def parse_input(file) do
    [raw_rules, raw_input] = Z.file_to_list(file) |> Z.chunk_filter_values("")

    regex = parse_rules(raw_rules) |> build()
    [raw_input, regex]
  end

  # End case for build without loops, clean it and pop into a regex sigil with ^/$
  def build(rules) when map_size(rules) == 1 do
    r = rules |> Map.get("0") |> String.replace(" ", "")
    {:ok, c} = :re2.compile("^#{r}$")
    c
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
          # Clean up any self-referencing rules with fakes
          |> String.replace(" #{rk} ", spoof_recursive(rk))

        Map.put(ra, rk, nv)
      end)
      # Drop the keys for the letters, this will shrink until only key "0" is left.
      |> Map.drop(Map.keys(letters))

    build(new_rules)
  end

  defp spoof_recursive(input = 8) do
    for i <- 1..5, into: "" do
      String.duplicate(" 42 ", i) <> "|"
    end
    |> String.trim_trailing("|")
  end

  defp spoof_recursive(input = 11) do
    for i <- 1..5, into: "" do
      String.duplicate(" 42 ", i) <> String.duplicate(" 31 ", i) <> "|"
    end
    |> String.trim_trailing("|")
  end

  defp spoof_recursive(input), do: input

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

Advent.part_2()
# IO.puts("Part 1: #{Advent.part_1()}")
# Advent.spoof_recursive(8) |> Z.debug()
