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
      b1.bottom == b2.top -> {true, :bottom}
      b1.right == b2.left -> {true, :right}
      b1.left == b2.right -> {true, :left}
      #  b1.top == b2.bottom -> {true, :top}
      true -> {false, nil}
    end
  end

  def nop(b = %Block{}), do: b

  def mirror(b = %Block{}) do
    mirrored_content = Enum.map(b.content, fn row -> String.reverse(row) end)
    Map.replace(b, :content, mirrored_content) |> update_edges()
  end

  def flip(b = %Block{}) do
    flipped_content = b.content |> Enum.reverse()
    Map.replace(b, :content, flipped_content) |> update_edges()
  end

  def flip_90(b = %Block{}), do: b |> flip() |> rotate_90() |> update_edges()
  def flip_180(b = %Block{}), do: b |> flip() |> rotate_180() |> update_edges()
  def flip_270(b = %Block{}), do: b |> flip() |> rotate_270() |> update_edges()

  def rot90_flip(b = %Block{}), do: b |> rotate_90() |> flip() |> update_edges()
  def rot180_flip(b = %Block{}), do: b |> rotate_180() |> flip() |> update_edges()
  def rot270_flip(b = %Block{}), do: b |> rotate_270() |> flip() |> update_edges()

  def rot90_mirror(b = %Block{}), do: b |> rotate_90() |> mirror() |> update_edges()
  def rot180_mirror(b = %Block{}), do: b |> rotate_180() |> mirror() |> update_edges()
  def rot270_mirror(b = %Block{}), do: b |> rotate_270() |> mirror() |> update_edges()

  def mirror_flip(b = %Block{}), do: b |> flip() |> mirror() |> update_edges()

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
  @cryptid_width 20
  @cryptid_0 ~r/[#.]{18}#[#.]/
  @cryptid_1 ~r/(#)[#.]{4}##[#.]{4}##[#.]{4}###/
  @cryptid_2 ~r/[#.]#[#.]{2}#[#.]{2}#[#.]{2}#[#.]{2}#[#.]{2}#[#.]{3}/

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

    start =
      blocks
      |> List.first()
      |> Block.flip()
      |> Block.set_coords(0, 0)

    # |> Block.set_xform(&Block.flip/1)

    blocks = blocks |> Block.replace_block(start)

    IO.puts("Starting block: #{start.id} ")

    sea =
      build_mosiac(blocks, nil, 1)
      |> Z.debug()
      |> Enum.map(&Block.trim_block(&1))
      |> build_sea()
      |> Block.flip()
      |> Block.rotate_90()

    # |> Block.rot90_flip()

    Block.print(sea)
    sea_width = sea |> Map.get(:top) |> String.length()
    scan_for_cryptids(sea.content, sea_width, 0) |> Z.debug()
  end

  def scan_for_cryptids([first, second, third | rest], sea_width, count) do
    count = count + scan_row(first, second, third, sea_width)
    scan_for_cryptids([second, third] ++ rest, sea_width, count)
  end

  def scan_for_cryptids(_, _, count), do: count

  def scan_row(first, second, third, sea_width) do
    for i <- 0..(sea_width - @cryptid_width), into: [] do
      found =
        Regex.match?(@cryptid_0, String.slice(first, i..(@cryptid_width + i - 1))) and
          Regex.match?(@cryptid_1, String.slice(second, i..(@cryptid_width + i - 1))) and
          Regex.match?(@cryptid_2, String.slice(third, i..(@cryptid_width + i - 1)))

      if found, do: 1, else: 0
    end
    |> Enum.sum()
  end

  def build_sea(blocks) do
    block_height = blocks |> List.first() |> Map.get(:content) |> Kernel.length()
    x_min = Enum.map(blocks, fn block -> block.x end) |> Enum.min()
    x_max = Enum.map(blocks, fn block -> block.x end) |> Enum.max()
    y_min = Enum.map(blocks, fn block -> block.y end) |> Enum.min()
    y_max = Enum.map(blocks, fn block -> block.y end) |> Enum.max()

    sea_content =
      for y <- y_max..y_min do
        for r <- 0..(block_height - 1), into: "" do
          for x <- x_min..x_max, into: "" do
            block = Enum.find(blocks, fn block -> block.x == x and block.y == y end)
            Map.get(block, :content) |> Enum.at(r)
          end <> "\n"
        end
      end
      |> Enum.join("")
      |> String.split("\n")
      |> Enum.reject(fn s -> s == "" end)

    Block.new(id: :sea, content: sea_content)
  end

  def build_mosiac(blocks, :done, _), do: blocks
  def build_mosiac(blocks, _, 1000), do: blocks

  def build_mosiac(blocks, _, acc) do
    new_blocks =
      Enum.reduce(blocks, blocks, fn b, acc ->
        find_adjacencies(acc, b)
      end)

    if all_visited?(blocks) do
      Enum.count(blocks, fn b -> b.visited end) |> Z.debug()
      build_mosiac(new_blocks, :done, acc + 1)
    else
      Enum.count(blocks, fn b -> b.visited end) |> Z.debug()
      build_mosiac(new_blocks, nil, acc + 1)
    end
  end

  def all_visited?(blocks), do: Enum.all?(blocks, fn b -> b.visited end)

  defp find_adjacencies(blocks, %Block{found: false}), do: blocks

  defp find_adjacencies(blocks, cur_block = %{visited: false}) do
    ops = [
      &Block.nop/1,
      &Block.rotate_90/1,
      &Block.rotate_180/1,
      &Block.rotate_270/1,
      &Block.flip/1,
      &Block.flip_90/1,
      &Block.flip_180/1,
      &Block.flip_270/1
      #  &Block.rot90_flip/1,
      #   &Block.rot180_flip/1,
      #  &Block.rot270_flip/1,
      #  &Block.rot90_mirror/1,
      #  &Block.rot180_mirror/1,
      #  &Block.rot270_mirror/1,
      #    &Block.mirror/1,
      #    &Block.mirror_flip/1
    ]

    Enum.reduce(blocks, [], fn b, acc ->
      r =
        if b.id != cur_block.id do
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

  defp find_adjacencies(blocks, %Block{}), do: blocks

  defp test_block(%Block{visited: true}, _, _), do: []

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
