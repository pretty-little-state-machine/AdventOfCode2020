defmodule Advent do
  @doc """
  Splits a string of passport data into a map based on key / value.
  """
  def datastring_to_map(data) do
    data
    |> String.split(" ")
    |> Enum.map(fn x ->
      x
      |> String.split(":")
      |> Enum.chunk(2)
      |> Map.new(fn [k, v] -> {k, v} end)
    end)
    |> Enum.reduce(fn x, acc -> Map.merge(x, acc) end)
  end

  def is_valid?(passport) do
    passport
    |> Enum.map(fn {k, v} -> valid_field?(%{k => v}) end)
    |> Enum.all?()
  end

  def valid_field?(%{"byr" => value}) do
    is_in_range_inc?(value, 1920, 2002)
  end

  def valid_field?(%{"iyr" => value}) do
    is_in_range_inc?(value, 2010, 2020)
  end

  def valid_field?(%{"eyr" => value}) do
    is_in_range_inc?(value, 2020, 2030)
  end

  def valid_field?(%{"hgt" => value}) do
    if String.contains?(value, "cm") do
      value
      |> String.replace("cm", "")
      |> is_in_range_inc?(150, 193)
    else
      value
      |> String.replace("in", "")
      |> is_in_range_inc?(59, 76)
    end
  end

  def valid_field?(%{"hcl" => value}) do
    String.match?(value, ~r/#[0-9a-f]{6}/)
  end

  def valid_field?(%{"ecl" => value}) do
    Enum.any?([
      "amb" == value,
      "blu" == value,
      "brn" == value,
      "gry" == value,
      "grn" == value,
      "hzl" == value,
      "oth" == value
    ])
  end

  def valid_field?(%{"pid" => value}) do
    String.match?(value, ~r/^[0-9]{9}$/)
  end

  def valid_field?(_map) do
    true
  end

  def is_in_range_inc?(value, min, max) do
    i = String.to_integer(value)
    min <= i and i <= max
  end

  def is_in_range_inc_old?(value, min, max) do
    int = case Integer.parse(value) do
      {num, ""} -> {:ok, num}
      {_, _} -> {:error, :unparsable}
      :error -> {:error, :unparsable}
    end

    case int do
      {:ok, num } -> cond do
        num >= min -> true
        num <= max -> true
        true -> false
      end
      {:error, _} -> false
      {_, _} -> false
    end
  end
end

req_fields = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]
{:ok, input} = File.read("./files/day_04_input.txt")

# Process
input
|> String.split("\n\n")
|> Enum.map(fn x -> String.replace(x, "\n" , " ") end)
|> Enum.map(fn x -> Advent.datastring_to_map(x) end)
|> Enum.filter(fn x ->
  Enum.all?(req_fields, fn(y) -> Map.has_key?(x, y) end)
end)
|> Enum.filter(fn x -> Advent.is_valid?(x) == true end) # Part II only.
|> Enum.count()
|> IO.puts()
