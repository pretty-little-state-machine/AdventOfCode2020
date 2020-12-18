Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  @active "#"
  @inactive "."
  @runs 6

  # Public Interface
  def part_1() do
    space = parse_input("files/day_17_input.txt")

    Enum.reduce(1..@runs, space, fn _, i_acc ->
      new_space = embiggen_space_3d(i_acc)

      Enum.reduce(new_space, %{}, fn {coords, cube}, s_acc ->
        num = count_num_surrounding_3d(i_acc, coords)
        new_cube = update_cube(cube, num)
        Map.put(s_acc, coords, new_cube)
      end)
    end)
    |> count_cubes()
  end

  # Public Interface
  def part_2() do
    space =
      parse_input("files/day_17_input.txt")
      |> Enum.reduce(%{}, fn {k, v}, acc ->
        {x, y, z} = k
        Map.put(acc, {x, y, z, 0}, v)
      end)

    Enum.reduce(1..@runs, space, fn _, i_acc ->
      new_space = embiggen_space_4d(i_acc)

      Enum.reduce(new_space, %{}, fn {coords, cube}, s_acc ->
        num = count_num_surrounding_4d(i_acc, coords)
        new_cube = update_cube(cube, num)
        Map.put(s_acc, coords, new_cube)
      end)
    end)
    |> count_cubes()
  end

  def print_3d(space) do
    coords = Map.keys(space)
    x_num = Enum.map(coords, fn t -> elem(t, 0) end) |> Enum.uniq() |> Enum.count()
    y_num = Enum.map(coords, fn t -> elem(t, 0) end) |> Enum.uniq() |> Enum.count()

    space
    |> Enum.sort_by(fn {x, _} -> {elem(x, 2), elem(x, 1), elem(x, 0)} end)
    |> Enum.chunk_every(x_num * y_num)
    |> Enum.each(fn i ->
      idx = i |> List.first() |> elem(0) |> elem(2)

      IO.puts("\nz=#{idx}")

      Enum.chunk_every(i, x_num)
      |> Enum.each(fn k ->
        Enum.each(k, fn {_, v} -> IO.write(v) end)
        IO.puts("")
      end)
    end)

    IO.puts("\n")

    space
  end

  defp count_cubes(space) do
    Enum.reduce(space, 0, fn s, acc ->
      {_, cube} = s
      acc + if(String.contains?(cube, @active), do: 1, else: 0)
    end)
  end

  defp get_cube(space, coords), do: Map.get(space, coords, @inactive)

  defp update_cube(cube, num_surround) when cube == @active and num_surround == 2,
    do: @active

  defp update_cube(cube, num_surround) when cube == @active and num_surround == 3,
    do: @active

  defp update_cube(cube, num_surround) when cube == @inactive and num_surround == 3,
    do: @active

  defp update_cube(cube, _) when cube == @inactive,
    do: @inactive

  defp update_cube(_, _), do: @inactive

  def count_num_surrounding_3d(space, coords) do
    build_search_positions_3d(-1, 1, -1, 1, -1, 1)
    |> Enum.reduce(0, fn s, acc ->
      dx = elem(coords, 0) + elem(s, 0)
      dy = elem(coords, 1) + elem(s, 1)
      dz = elem(coords, 2) + elem(s, 2)

      if(@active == get_cube(space, {dx, dy, dz}), do: acc + 1, else: acc)
    end)
  end

  defp embiggen_space_3d(space) do
    coords = Map.keys(space)
    {x_low, x_high} = Enum.map(coords, fn t -> elem(t, 0) end) |> Enum.min_max()
    {y_low, y_high} = Enum.map(coords, fn t -> elem(t, 1) end) |> Enum.min_max()
    {z_low, z_high} = Enum.map(coords, fn t -> elem(t, 2) end) |> Enum.min_max()

    build_space_3d(x_low - 1, x_high + 1, y_low - 1, y_high + 1, z_low - 1, z_high + 1)
    |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, @inactive) end)
    |> Map.merge(space)
    |> Enum.sort_by(fn {x, _} -> {elem(x, 2), elem(x, 1), elem(x, 0)} end)
  end

  defp build_search_positions_3d(x_start, x_end, y_start, y_end, z_start, z_end) do
    build_space_3d(x_start, x_end, y_start, y_end, z_start, z_end)
    # Don't include the origin
    |> Enum.filter(fn x -> x != {0, 0, 0} end)
  end

  defp build_space_3d(x_start, x_end, y_start, y_end, z_start, z_end) do
    for x <- x_start..x_end, into: [] do
      for y <- y_start..y_end, into: [] do
        for z <- z_start..z_end, into: [], do: {x, y, z}
      end
    end
    |> List.flatten()
  end

  # 4-D Hyperspace!
  def count_num_surrounding_4d(space, coords) do
    build_search_positions_4d(-1, 1, -1, 1, -1, 1, -1, 1)
    |> Enum.reduce(0, fn s, acc ->
      dx = elem(coords, 0) + elem(s, 0)
      dy = elem(coords, 1) + elem(s, 1)
      dz = elem(coords, 2) + elem(s, 2)
      dw = elem(coords, 3) + elem(s, 3)

      if(@active == get_cube(space, {dx, dy, dz, dw}), do: acc + 1, else: acc)
    end)
  end

  defp embiggen_space_4d(space) do
    coords = Map.keys(space)
    {x_low, x_high} = Enum.map(coords, fn t -> elem(t, 0) end) |> Enum.min_max()
    {y_low, y_high} = Enum.map(coords, fn t -> elem(t, 1) end) |> Enum.min_max()
    {z_low, z_high} = Enum.map(coords, fn t -> elem(t, 2) end) |> Enum.min_max()
    {w_low, w_high} = Enum.map(coords, fn t -> elem(t, 3) end) |> Enum.min_max()

    build_space_4d(
      x_low - 1,
      x_high + 1,
      y_low - 1,
      y_high + 1,
      z_low - 1,
      z_high + 1,
      w_low - 1,
      w_high + 1
    )
    |> Enum.reduce(%{}, fn c, acc -> Map.put(acc, c, @inactive) end)
    |> Map.merge(space)
  end

  defp build_search_positions_4d(x_start, x_end, y_start, y_end, z_start, z_end, w_start, w_end) do
    build_space_4d(x_start, x_end, y_start, y_end, z_start, z_end, w_start, w_end)
    # Don't include the origin
    |> Enum.filter(fn x -> x != {0, 0, 0, 0} end)
  end

  defp build_space_4d(x_start, x_end, y_start, y_end, z_start, z_end, w_start, w_end) do
    for x <- x_start..x_end, into: [] do
      for y <- y_start..y_end, into: [] do
        for z <- z_start..z_end, into: [] do
          for w <- w_start..w_end, into: [], do: {x, y, z, w}
        end
      end
    end
    |> List.flatten()
  end

  @doc """
  Creates a map of space of slize Z=0
    %{
      {2, 1, 0} => ".",
     }
  """
  def parse_input(file) do
    Z.file_to_list(file)
    |> Enum.map(&String.graphemes/1)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn y, y_acc ->
      {y_val, y_idx} = y

      y_val
      |> Enum.with_index()
      |> Enum.reduce(y_acc, fn x, x_acc ->
        {x_val, x_idx} = x
        Map.put(x_acc, {x_idx, y_idx, 0}, x_val)
      end)
      |> Map.merge(y_acc)
    end)
  end
end

IO.puts("Part 1: #{Advent.part_1()}")
IO.puts("Part 2: #{Advent.part_2()}")
