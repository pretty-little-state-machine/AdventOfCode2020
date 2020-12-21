Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Block do
  defstruct id: 0,
            found: false,
            content: "",
            left: "",
            right: "",
            top: "",
            bottom: "",
            shared_edges: 0,
            x: nil,
            y: nil,
            visited: false

  def new(id: id, content: content) do
    %Block{
      id: id,
      shared_edges: 0,
      content: content
    }
    |> update_edges()
  end

  def set_visited(b = %Block{}), do: Map.replace(b, :visited, true)

  def set_coords(b = %Block{}, x, y) do
    b
    |> Map.replace(:x, x)
    |> Map.replace(:y, y)
    |> Map.replace(:found, true)
  end

  defp update_edges(b = %Block{}) do
    b
    |> Map.replace(:top, List.first(b.content))
    |> Map.replace(:bottom, List.last(b.content))
    |> Map.replace(
      :right,
      Enum.reduce(b.content, "", fn x, acc -> acc <> (String.graphemes(x) |> List.last()) end)
    )
    |> Map.replace(
      :left,
      Enum.reduce(b.content, "", fn x, acc -> acc <> (String.graphemes(x) |> List.first()) end)
    )
  end

  def is_adjacent(b1 = %Block{}, b2 = %Block{}) do
    cond do
      # b1.top == b2.bottom -> {true, :top}
      b1.bottom == b2.top -> {true, :bottom}
      b1.right == b2.left -> {true, :right}
      b1.left == b2.right -> {true, :left}
      true -> {false, nil}
    end
  end

  def nop(b = %Block{}), do: b

  def flip(b = %Block{}) do
    flipped_content = b.content |> Enum.reverse()
    Map.replace(b, :content, flipped_content) |> update_edges()
  end

  def trim_block(b = %Block{}) do
    new_content =
      b.content
      |> List.delete_at(0)
      |> List.delete_at(-1)
      |> Enum.map(&trim_edges(&1))

    Map.replace(b, :content, new_content)
  end

  def print(b = %Block{}, trim \\ false) do
    rows =
      if trim do
        b.content |> List.delete_at(0) |> List.delete_at(-1)
      else
        b.content
      end

    Enum.each(rows, fn x ->
      if trim do
        x |> trim_edges() |> IO.puts()
      else
        x |> IO.puts()
      end
    end)

    b
  end

  def print_row(b = %Block{}, row, trim \\ false) do
    if trim do
      b.content
      |> Enum.at(row)
      |> trim_edges()
      |> IO.write()
    else
      IO.write(b.content |> Enum.at(row))
    end

    b
  end

  defp trim_edges(string) do
    string
    |> String.graphemes()
    |> List.delete_at(0)
    |> List.delete_at(-1)
    |> Enum.join()
  end

  def rotate_90(b = %Block{}),
    do: b |> rotate_cw()

  def rotate_180(b = %Block{}),
    do: b |> rotate_cw() |> rotate_cw()

  def rotate_270(b = %Block{}),
    do: b |> rotate_cw() |> rotate_cw() |> rotate_cw()

  defp rotate_cw(b = %Block{}) do
    new_content =
      b.content
      |> Enum.map(&String.graphemes(&1))
      |> Z.rotate()
      |> Enum.map(&Enum.join(&1))

    Map.replace(b, :content, new_content) |> update_edges()
  end

  def replace_block(blocks, block),
    do: Enum.map(blocks, fn b -> if b.id == block.id, do: block, else: b end)

  def get_all_edges(blocks) do
    Enum.reduce(blocks, [], fn b, acc ->
      acc ++ get_block_edges(b)
    end)
  end

  def get_block_edges(b = %Block{}) do
    [b.top, b.bottom, b.right, b.left] ++
      [b.top |> String.reverse(), b.bottom |> String.reverse()] ++
      [b.right |> String.reverse(), b.left |> String.reverse()]
  end
end

defmodule Advent do
  @doc """
  Advent Day 20
  """
  def part_1() do
    parse("files/day_20_input.txt")
    |> count_unmatched_edges()
    |> Enum.filter(fn x -> x.shared_edges == 2 end)
    |> Enum.reduce(1, fn b, acc -> acc * b.id end)
  end

  def part_2() do
    blocks =
      parse("files/day_20_input.txt")
      |> count_unmatched_edges()

    start = blocks |> List.first() |> Block.flip() |> Block.set_coords(0, 0)
    blocks = blocks |> Block.replace_block(start)

    IO.puts("Starting block: #{start.id} ")
    recurse(blocks, nil, 1)
  end

  def recurse(blocks, :done, _), do: blocks |> Z.debug()

  def recurse(blocks, _, 100_000) do
    blocks |> Z.debug()
    IO.puts("Break - Recursive Limit")
  end

  def recurse(blocks, _, acc) do
    new_blocks =
      Enum.reduce(blocks, blocks, fn b, acc ->
        find_adjacencies(acc, b)
      end)

    if all_visited?(blocks) do
      recurse(new_blocks, :done, acc + 1)
    else
      recurse(new_blocks, nil, acc + 1)
    end
  end

  def all_visited?(blocks) do
    Enum.all?(blocks, fn x -> x.found end)
  end

  defp find_adjacencies(blocks, cur_block = %Block{found: false}), do: blocks

  defp find_adjacencies(blocks, cur_block) do
    ops = [
      &Block.nop/1,
      &Block.rotate_90/1,
      &Block.rotate_180/1,
      &Block.rotate_270/1,
      &Block.flip/1
    ]

    Enum.reduce(blocks, [], fn b, acc ->
      r =
        if b.id != cur_block.id and !cur_block.visited do
          Enum.reduce(ops, [], fn o, o_acc ->
            o_acc ++ test_block(b, cur_block, o)
          end)
        else
          []
        end

      acc ++ r
    end)
    |> Enum.reject(fn x -> x == [] end)
    # Update blocks with new flipped around members
    |> Enum.reduce(blocks, fn b, acc ->
      Block.replace_block(acc, b)
    end)
    # Update visited for current block
    |> Block.replace_block(Block.set_visited(cur_block))
  end

  # defp filter_blocks(blocks, blocks_to_remove) do
  #  ids_to_remove = Enum.map(blocks_to_remove, fn b -> b.id end)
  #
  #   Enum.reduce(blocks, [], fn b, acc ->
  #    acc ++ if b.id in ids_to_remove, do: [], else: [b]
  #   end)
  # end

  defp test_block(b, cur_block, func) do
    b_test = func.(b)
    {test, adj} = Block.is_adjacent(cur_block, b_test)

    if test do
      IO.write("#{cur_block.id} (#{cur_block.x}, #{cur_block.y})")
      IO.puts(": MATCH! #{b_test.id} : #{adj}")

      cond do
        adj == :top -> [b_test |> Block.set_coords(cur_block.x, cur_block.y + 1)]
        adj == :bottom -> [b_test |> Block.set_coords(cur_block.x, cur_block.y - 1)]
        adj == :left -> [b_test |> Block.set_coords(cur_block.x - 1, cur_block.y)]
        adj == :right -> [b_test |> Block.set_coords(cur_block.x + 1, cur_block.y)]
      end
    else
      []
    end
  end

  defp count_unmatched_edges(blocks) do
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

    Block.new(id: id, content: rest)
  end
end

# IO.puts("Part 1: #{Advent.part_1()}")
Advent.part_2()
