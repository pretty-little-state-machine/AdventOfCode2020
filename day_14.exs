defmodule Advent do
  @ram_size 65_535

  def part_1(input) do
    ram = List.duplicate(0, @ram_size)

    Enum.reduce(input, ram, fn x, acc ->
      Enum.reduce(
        x.ops,
        acc,
        fn o, o_acc ->
          List.replace_at(o_acc, o.addr, run_bitmask_pt1(o.val, x.mask))
        end
      )
    end)
    |> Enum.sum()
  end

  def run_bitmask_pt1(value, mask) do
    binary = Integer.to_string(value, 2) |> String.graphemes()
    padding = String.duplicate("0", 36 - Kernel.length(binary)) |> String.graphemes()

    zip = Enum.zip(padding ++ binary, String.graphemes(mask))

    for z <- zip, into: "" do
      {val, mask} = z

      cond do
        mask == "X" -> val
        mask == "1" -> "1"
        mask == "0" -> "0"
      end
    end
    |> String.to_integer(2)
  end

  def run_bitmask_pt2(addr, mask) do
    binary = Integer.to_string(addr, 2) |> String.graphemes()
    padding = String.duplicate("0", 36 - Kernel.length(binary)) |> String.graphemes()

    zip = Enum.zip(padding ++ binary, String.graphemes(mask))

    for z <- zip, into: "" do
      {val, mask} = z

      cond do
        mask == "X" -> "F"
        mask == "1" -> "1"
        mask == "0" -> val
      end
    end
    |> IO.inspect()

    # |> String.to_integer(2)
  end

  @doc """
  Returns a list of the following map:
    %{
      mask: "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X",
      ops: [
        %{addr: 8, val: 11},
        %{addr: 7, val: 101},
        %{addr: 8, val: 0}
      ]
    }
  """
  def parse_input(input) do
    blocks =
      input
      |> String.replace("\r", "")
      |> String.split("\n")
      |> Enum.chunk_by(fn x -> String.contains?(x, "mask =") end)

    masks =
      blocks
      |> Enum.take_every(2)
      |> Enum.map(fn x -> List.first(x) |> String.replace("mask = ", "") end)

    ops =
      blocks
      |> List.delete_at(0)
      |> Enum.take_every(2)
      |> Enum.map(fn x ->
        Enum.map(x, fn y ->
          m = Regex.run(~r/mem\[([\d]+)\] = ([\d]+)/, y)

          %{
            addr: Enum.at(m, 1) |> String.to_integer(),
            val: Enum.at(m, 2) |> String.to_integer()
          }
        end)
      end)

    Enum.zip(masks, ops)
    |> Enum.map(fn x ->
      {mask, ops} = x
      %{mask: mask, ops: ops}
    end)
  end
end

{:ok, input} = File.read("./files/day_14_input.txt")
p1 = Advent.parse_input(input) |> Advent.part_1()
IO.puts("Part 1: #{p1}")

# p2 = Advent.parse_input_part_2(input) |> Advent.part_2()
# IO.puts("Part 2: #{p2}")
