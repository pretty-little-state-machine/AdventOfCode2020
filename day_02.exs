defmodule AoC2020 do
  def get_valid_rule_1(path, rule) do
    {:ok, data} = File.read(path)

    data
    |> String.split("\n", trim: true)
    |> Enum.filter(rule)
  end

  def is_valid_rule_1?(input) do
    [rule, password] = String.split(input, ":", trim: true)
    [values, letter] = String.split(rule, " ", trim: true)
    [min, max] = String.split(values, "-", trim: true)

    count =
      password
      |> String.graphemes()
      |> Enum.frequencies()
      |> Map.get(letter)

    String.to_integer(min) <= count and count <= String.to_integer(max)
  end

  def is_valid_rule_2?(input) do
    [rule, password] = String.split(input, ":", trim: true)
    [values, letter] = String.split(rule, " ", trim: true)
    [pos_1, pos_2] = String.split(values, "-", trim: true)

    pos_1_found = letter == String.at(password, String.to_integer(pos_1))
    pos_2_found = letter == String.at(password, String.to_integer(pos_2))
    xor(pos_1_found, pos_2_found)
  end

  defp xor(a, b) when a == true and b == true, do: false
  defp xor(a, b) when a == true and b == false, do: true
  defp xor(a, b) when a == false and b == true, do: true
  defp xor(_a, _b), do: false
end

AoC2020.get_valid_rule_1("files/day_2_input.txt", &AoC2020.is_valid_rule_1?/1)
|> Enum.count()
|> IO.puts()

AoC2020.get_valid_rule_1("files/day_2_input.txt", &AoC2020.is_valid_rule_2?/1)
|> Enum.count()
|> IO.puts()
