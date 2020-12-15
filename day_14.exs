defmodule Advent do
  def part_1(input) do
    Enum.reduce(input, %{}, fn x, acc ->
      Enum.reduce(
        x.ops,
        acc,
        fn o, o_acc ->
          Map.put(o_acc, o.addr, run_bitmask_pt1(o.val, x.mask))
        end
      )
    end)
    |> Enum.to_list()
    |> Enum.map(fn x ->
      {_, v} = x
      v
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

  def part_2(input) do
    Enum.reduce(input, %{}, fn x, acc ->
      Enum.reduce(
        x.ops,
        acc,
        fn o, o_acc ->
          addrs = run_bitmask_pt2(o.addr, x.mask)

          Enum.reduce(addrs, o_acc, fn a, a_acc -> Map.put(a_acc, a, o.val) end)
        end
      )
    end)
    |> Enum.to_list()
    |> Enum.map(fn x ->
      {_, v} = x
      v
    end)
    |> Enum.sum()
  end

  def run_bitmask_pt2(addr, mask) do
    binary = Integer.to_string(addr, 2) |> String.graphemes()
    padding = String.duplicate("0", 36 - Kernel.length(binary)) |> String.graphemes()

    zip = Enum.zip(padding ++ binary, String.graphemes(mask))

    round_1 =
      for z <- zip, into: "" do
        {val, mask} = z

        cond do
          mask == "X" -> "X"
          mask == "1" -> "1"
          mask == "0" -> val
        end
      end

    offsets =
      round_1
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn x ->
        {v, _} = x
        "X" == v
      end)
      |> Enum.map(fn x ->
        {_, idx} = x
        idx
      end)

    build_maps(round_1, offsets, [])
    |> Enum.uniq()
    |> Enum.map(fn x -> String.to_integer(x, 2) end)
  end

  def build_maps(_, [], acc), do: acc

  def build_maps(mask, offsets, _) do
    {offset, new_offsets} = List.pop_at(offsets, 0)

    addr_0 = replace_in_mask(mask, offset, 0)
    addr_1 = replace_in_mask(mask, offset, 1)

    build_maps(addr_0, new_offsets, [addr_0, addr_1]) ++
      build_maps(addr_1, new_offsets, [addr_0, addr_1])
  end

  defp replace_in_mask(mask, idx, val) do
    mask
    |> String.graphemes()
    |> List.replace_at(idx, val)
    |> Enum.join("")
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

p2 = Advent.parse_input(input) |> Advent.part_2()
IO.puts("Part 2: #{p2}")
