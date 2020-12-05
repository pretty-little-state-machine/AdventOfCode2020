defmodule Advent do
  def get_seat_id(boarding_pass) do
    r = boarding_pass |> String.slice(0..6) |> decode("F", "B")
    c = boarding_pass |> String.slice(7..9) |> decode("L", "R")
    r * 8 + c
  end

  def decode(bits, zero_mask, one_mask) do
    bits
    |> String.replace(zero_mask, "0")
    |> String.replace(one_mask, "1")
    |> String.to_integer(2)
  end
end

{:ok, input} = File.read("./files/day_05_input.txt")

passes =
  input
  |> String.split("\n")
  |> Enum.map(fn x -> Advent.get_seat_id(x) end)
  |> Enum.sort(:desc)

# Part 1
high = List.first(passes)
IO.puts(high)

# Part 2
low = List.last(passes)
all_passes = Enum.to_list(low..high)
IO.puts((all_passes -- passes) |> List.first())
