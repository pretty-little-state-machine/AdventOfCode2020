defmodule Advent do
  @max_finds 100_000_000

  def part_1() do
    card_public = 19_774_466
    door_public = 7_290_641
    card_loop = find_loop(card_public, 7)
    door_loop = find_loop(door_public, 7)
    IO.puts("Card Public: #{card_public} - #{card_loop} loops")
    IO.puts("Door Public: #{door_public} - #{door_loop} loops")

    card_encryption = run_loop(door_public, card_loop)
    door_encryption = run_loop(card_public, door_loop)
    IO.puts("Card Encryption: #{card_encryption}")
    IO.puts("Door Encryption: #{door_encryption}")
  end

  def run_loop(subject_number, num_loops) do
    Enum.reduce(1..(num_loops - 1), subject_number, fn _, acc ->
      loop(subject_number, acc)
    end)
  end

  def find_loop(pub_key, subject_number) do
    Enum.reduce_while(1..@max_finds, %{iter: 0, value: 1}, fn _, acc ->
      if acc.value == pub_key do
        {:halt, acc.iter}
      else
        acc = %{iter: acc.iter + 1, value: loop(subject_number, acc.value)}
        {:cont, acc}
      end
    end)
  end

  def loop(subject, value), do: rem(value * subject, 2020_12_27)
end

Advent.part_1()
