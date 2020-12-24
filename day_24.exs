Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Hexa do
  @doc """
  A hexagonal grid representation using cubic form coordinates.
  Read this: https://www.redblobgames.com/grids/hexagons/
  """
  def new(), do: %{x: 0, y: 0, z: 0, color: :white}
  def new(x, y, z), do: %{x: x, y: y, z: z, color: :white}

  def move(hex, :ne), do: move(hex, 1, 0, -1)
  def move(hex, :e), do: move(hex, 1, -1, 0)
  def move(hex, :se), do: move(hex, 0, -1, 1)
  def move(hex, :sw), do: move(hex, -1, 0, 1)
  def move(hex, :w), do: move(hex, -1, 1, 0)
  def move(hex, :nw), do: move(hex, 0, 1, -1)

  def to_key(hex), do: "#{hex.x},#{hex.y},#{hex.z}"

  def flip(hex = %{color: :white}), do: %{hex | color: :black}
  def flip(hex = %{color: :black}), do: %{hex | color: :white}
  def flip(hex), do: hex

  defp move(hex, x, y, z),
    do: %{hex | x: hex.x + x, y: hex.y + y, z: hex.z + z}
end

defmodule Advent do
  @regex ~r{se|sw|ne|nw|e|w}

  def part_1() do
    parse_file()
    |> get_initial_tilestate()
    |> count_tiles()
    |> Map.get(:black)
  end

  def part_2() do
    tiles = parse_file() |> get_initial_tilestate()
    # Garbage collector goes Brrrrrrrrrrrr.... This is horrific.
    Enum.reduce(1..100, tiles, fn i, acc ->
      res = run_rules(acc)
      count = count_tiles(res) |> Map.get(:black)
      IO.puts("Run #{i}:  #{count}")
      res
    end)
  end

  def run_rules(tiles) do
    # Expand the space first to all potential neighbors
    tiles =
      Enum.reduce(tiles, tiles, fn {_key, tile}, acc ->
        neighbors = get_neighbors(tiles, tile)
        Map.merge(neighbors, acc)
      end)

    # Now run the ruleset on the expanded space
    Enum.reduce(tiles, tiles, fn {_key, tile}, acc ->
      neighbors = get_neighbors(tiles, tile)
      new_tile = run_rule(tile, neighbors |> count_tiles())
      # Do not replace any existing tiles, but add neighbors and update the tile
      Map.merge(neighbors, acc) |> Map.put(Hexa.to_key(new_tile), new_tile)
    end)
  end

  def run_rule(tile, counts) when tile.color == :black and counts.black == 0,
    do: Hexa.flip(tile)

  def run_rule(tile, counts) when tile.color == :black and counts.black > 2,
    do: Hexa.flip(tile)

  def run_rule(tile, counts) when tile.color == :white and counts.black == 2,
    do: Hexa.flip(tile)

  def run_rule(tile, _), do: tile

  def get_neighbors(tiles, tile) do
    [:ne, :e, :se, :sw, :w, :nw]
    |> Enum.reduce(%{}, fn dir, acc ->
      n = get_neighbor(tiles, tile, dir)
      Map.merge(acc, n)
    end)
  end

  def get_neighbor(tiles, tile, direction) do
    cur = tile |> Hexa.move(direction)
    # Builds a new tile if the neighbor doesn't exist yet.
    n = Map.get(tiles, Hexa.to_key(cur), Hexa.new(cur.x, cur.y, cur.z))
    Map.put(%{}, Hexa.to_key(n), Map.get(tiles, Hexa.to_key(n), Hexa.new(n.x, n.y, n.z)))
  end

  def get_initial_tilestate(tiles) do
    Enum.map(tiles, &travel(&1))
    |> Enum.reduce(%{}, fn t, acc ->
      # Use the accumulator version of the tile if present
      cur_tile = Map.get(acc, Hexa.to_key(t), t)
      Map.put(acc, Hexa.to_key(cur_tile), cur_tile |> Hexa.flip())
    end)
  end

  def count_tiles(tiles) do
    Enum.reduce(tiles, %{black: 0, white: 0}, fn {_, t}, acc ->
      if t.color == :black do
        %{acc | black: acc.black + 1}
      else
        %{acc | white: acc.white + 1}
      end
    end)
  end

  def travel(path),
    do: Enum.reduce(path, Hexa.new(), fn m, hex -> Hexa.move(hex, m) end)

  def parse_file() do
    # [[:w, :se, :w, :e, :e], [:ne, :se, :e, :e]]
    Z.file_to_list("files/day_24_input.txt")
    |> Enum.map(fn s ->
      Regex.scan(@regex, s)
      |> Enum.map(&List.first(&1))
      |> Enum.map(&String.to_atom(&1))
    end)
  end
end

IO.puts("Part 1: #{Advent.part_1()} black tiles")
Advent.part_2()
