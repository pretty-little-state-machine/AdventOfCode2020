Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Block do
  defstruct id: 0, left: "", right: "", top: "", bottom: "", shared_edges: 0

  def are_adjacent?(b1 = %Block{}, b2 = %Block{}) do
    b1.top == b1.bottom or
      b1.bottom == b2.top or
      b1.right == b2.left or
      b2.left == b1.right
  end

  def nop(b = %Block{}), do: b

  def flip(b = %Block{}),
    do: %Block{
      id: b.id,
      shared_edges: b.shared_edges,
      top: b.bottom,
      bottom: b.top,
      right: b.right |> String.reverse(),
      left: b.left |> String.reverse()
    }

  def mirror(b = %Block{}),
    do: %Block{
      id: b.id,
      shared_edges: b.shared_edges,
      top: b.top |> String.reverse(),
      bottom: b.bottom |> String.reverse(),
      right: b.left,
      left: b.right
    }

  def rotate_90(b = %Block{}),
    do: b |> rotate_cw()

  def rotate_180(b = %Block{}),
    do: b |> rotate_cw() |> rotate_cw()

  def rotate_270(b = %Block{}),
    do: b |> rotate_cw() |> rotate_cw() |> rotate_cw()

  defp rotate_cw(b = %Block{}),
    do: %Block{
      id: b.id,
      shared_edges: b.shared_edges,
      top: b.left |> String.reverse(),
      bottom: b.right |> String.reverse(),
      right: b.top,
      left: b.bottom
    }

  def replace_block(blocks, block),
    do: Enum.map(blocks, fn b -> if b.id == block.id, do: block, else: b end)

  def get_all_edges(blocks) do
    Enum.reduce(blocks, [], fn b, acc ->
      acc ++
        [b.top, b.bottom, b.right, b.left] ++
        [b.top |> String.reverse(), b.bottom |> String.reverse()] ++
        [b.right |> String.reverse(), b.left |> String.reverse()]
    end)
  end

  def get_block_edges(b = %Block{}) do
    [b.top, b.bottom, b.right, b.left] ++
      [b.top |> String.reverse(), b.bottom |> String.reverse()] ++
      [b.right |> String.reverse(), b.left |> String.reverse()]
  end
end

defmodule Advent do
  def part_1() do
    parse("files/day_20_input.txt")
    |> count_unmatched_edges()
    |> Enum.filter(fn x -> x.shared_edges == 2 end)
    |> Enum.reduce(1, fn b, acc -> acc * b.id end)
  end

  def count_unmatched_edges(blocks) do
    edges = Block.get_all_edges(blocks)

    Enum.map(blocks, fn b ->
      cur_block_edges = Block.get_block_edges(b)
      rest_edges = edges -- cur_block_edges

      count =
        (Enum.reduce(rest_edges, 0, fn e, acc ->
           acc + if e in cur_block_edges, do: 1, else: 0
         end) / 2)
        |> ceil

      Map.put(b, :shared_edges, count)
    end)
  end

  defp parse(file) do
    Z.file_to_list(file)
    |> Z.chunk_filter_values("")
    |> Enum.map(&parse_block(&1))
  end

  defp parse_block(block) do
    {id_line, rest} = List.pop_at(block, 0)
    id = id_line |> String.replace("Tile ", "") |> String.replace(":", "") |> String.to_integer()

    top = List.first(rest)
    bottom = List.last(rest)
    right = Enum.reduce(rest, "", fn x, acc -> acc <> (String.graphemes(x) |> List.last()) end)
    left = Enum.reduce(rest, "", fn x, acc -> acc <> (String.graphemes(x) |> List.first()) end)

    %Block{id: id, top: top, bottom: bottom, right: right, left: left}
  end
end

IO.puts("Part 1: #{Advent.part_1()}")
