Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Hexa do
  @doc """
  A hexagonal grid representation using cubic form coordinates.
  Read this: https://www.redblobgames.com/grids/hexagons/
  """
  def new(), do: %{x: 0, y: 0, z: 0, color: :white}
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
