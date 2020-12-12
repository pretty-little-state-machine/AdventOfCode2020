defmodule Benchmark do
  def measure(function) do
    function
    |> :timer.tc()
    |> elem(0)
    |> Kernel./(1_000_000)
  end
end

defmodule Advent do
  @floor "."
  @filled "#"
  @empty "L"
  @max_runs 500

  def simulate(input, min_empty_seats, seat_selection_fn) do
    layout = parse_input(input)

    steady_state =
      Enum.reduce_while(1..@max_runs, %{c: -1, l: layout}, fn _, acc ->
        new_layout = run_rules(acc.l, min_empty_seats, seat_selection_fn)
        occupied = new_layout |> count_filled_seats()

        if acc.c != occupied do
          {:cont, %{c: occupied, l: new_layout}}
        else
          {:halt, %{c: occupied, l: new_layout}}
        end
      end)

    IO.puts("Steady state! - #{steady_state.c} seats filled")
  end

  defp run_rules(layout, min_empty_eats, seat_selection_fn) do
    Enum.reduce(0..(layout["height"] - 1), %{}, fn r, r_acc ->
      cols =
        Enum.reduce(0..(layout["width"] - 1), %{}, fn c, c_acc ->
          num_filled = seat_selection_fn.(layout, r, c)
          Map.put(c_acc, c, update_seat(layout[r][c], num_filled, min_empty_eats))
        end)

      Map.put(r_acc, r, cols)
    end)
    |> Map.put("width", layout["width"])
    |> Map.put("height", layout["height"])
  end

  def count_num_surrounding(layout, row, col) do
    n_val(layout, row - 1, col - 1) + n_val(layout, row - 1, col) +
      n_val(layout, row - 1, col + 1) + n_val(layout, row, col - 1) +
      n_val(layout, row, col + 1) + n_val(layout, row + 1, col - 1) +
      n_val(layout, row + 1, col) + n_val(layout, row + 1, col + 1)
  end

  def count_num_in_sight(layout, row, col) do
    # Scan Right
    r =
      Enum.reduce_while((col + 1)..layout["width"], 0, fn x, _ ->
        seat = get_layout_seat(layout, row, x)

        cond do
          seat == @floor -> {:cont, 0}
          seat == @empty -> {:halt, 0}
          seat == @filled -> {:halt, 1}
        end
      end)

    # Scan Left
    l =
      Enum.reduce_while((col - 1)..-1, 0, fn x, _ ->
        seat = get_layout_seat(layout, row, x)

        cond do
          seat == @floor -> {:cont, 0}
          seat == @empty -> {:halt, 0}
          seat == @filled -> {:halt, 1}
        end
      end)

    # Scan Up
    u =
      Enum.reduce_while((row - 1)..-1, 0, fn x, _ ->
        seat = get_layout_seat(layout, x, col)

        cond do
          seat == @floor -> {:cont, 0}
          seat == @empty -> {:halt, 0}
          seat == @filled -> {:halt, 1}
        end
      end)

    # Scan Down
    d =
      Enum.reduce_while((row + 1)..layout["height"], 0, fn x, _ ->
        seat = get_layout_seat(layout, x, col)

        cond do
          seat == @floor -> {:cont, 0}
          seat == @empty -> {:halt, 0}
          seat == @filled -> {:halt, 1}
        end
      end)

    # Scan Up-Right
    {_i, ur} =
      Enum.reduce_while((col + 1)..layout["width"], {-1, 0}, fn x, acc ->
        {idx, _} = acc
        seat = get_layout_seat(layout, row + idx, x)

        cond do
          seat == @floor -> {:cont, {idx - 1, 0}}
          seat == @empty -> {:halt, {idx, 0}}
          seat == @filled -> {:halt, {idx, 1}}
        end
      end)

    # Scan Up-Left
    {_i, ul} =
      Enum.reduce_while((col - 1)..-1, {-1, 0}, fn x, acc ->
        {idx, _} = acc
        seat = get_layout_seat(layout, row + idx, x)

        cond do
          seat == @floor -> {:cont, {idx - 1, 0}}
          seat == @empty -> {:halt, {idx, 0}}
          seat == @filled -> {:halt, {idx, 1}}
        end
      end)

    # Scan Down-Right
    {_i, dr} =
      Enum.reduce_while((col + 1)..layout["width"], {1, 0}, fn x, acc ->
        {idx, _} = acc
        seat = get_layout_seat(layout, row + idx, x)

        cond do
          seat == @floor -> {:cont, {idx + 1, 0}}
          seat == @empty -> {:halt, {idx, 0}}
          seat == @filled -> {:halt, {idx, 1}}
        end
      end)

    # Scan Down-Left
    {_i, dl} =
      Enum.reduce_while((col - 1)..-1, {1, 0}, fn x, acc ->
        {idx, _} = acc
        seat = get_layout_seat(layout, row + idx, x)

        cond do
          seat == @floor -> {:cont, {idx + 1, 0}}
          seat == @empty -> {:halt, {idx, 0}}
          seat == @filled -> {:halt, {idx, 1}}
        end
      end)

    r + l + u + d + ur + dr + ul + dl
  end

  # Shared Logic - Parts 1 & 2
  defp get_layout_seat(layout, row, col) do
    if Map.has_key?(layout, row) do
      if Map.has_key?(layout[row], col) do
        layout[row][col]
      else
        @floor
      end
    else
      @floor
    end
  end

  defp n_val(layout, row, col) do
    if Map.has_key?(layout, row) do
      if Map.has_key?(layout[row], col) do
        if layout[row][col] === @filled do
          1
        else
          0
        end
      else
        0
      end
    else
      0
    end
  end

  defp update_seat(seat, num_surround, lim) when seat == @filled and num_surround >= lim,
    do: @empty

  defp update_seat(seat, num_surround, lim) when seat == @filled and num_surround < lim,
    do: @filled

  defp update_seat(seat, num_surround, _lim) when seat == @empty and num_surround == 0,
    do: @filled

  defp update_seat(seat, _num_surround, _lim) when seat == @empty,
    do: @empty

  defp update_seat(_, _, _), do: @floor

  defp count_filled_seats(layout) do
    Enum.reduce(0..(layout["height"] - 1), 0, fn r, r_acc ->
      r_acc +
        Enum.reduce(0..(layout["width"] - 1), 0, fn c, c_acc ->
          c_acc + n_val(layout, r, c)
        end)
    end)
  end

  defp print_layout(layout) do
    Enum.each(0..(layout["height"] - 1), fn r ->
      Enum.each(0..(layout["width"] - 1), fn c ->
        IO.write(layout[r][c])
      end)

      IO.puts("")
    end)

    IO.puts("\n\n")
    layout
  end

  # File Loader
  defp parse_input(input) do
    splits =
      input
      |> String.replace("\r", "")
      |> String.split("\n")

    height = Kernel.length(splits)
    width = List.first(splits) |> String.length()

    # Modify splits to have some fake tiles bordering it
    buffer = List.duplicate(@floor, List.first(splits) |> String.length()) |> Enum.join()
    splits = [buffer | splits] ++ [buffer]
    # Add left/right edges
    splits = Enum.map(splits, fn x -> @floor <> x <> @floor end)

    # Note the use of -1, which is creating the "hidden" offsets
    Enum.reduce(0..(height + 1), %{}, fn h, row ->
      column =
        Enum.reduce(0..(width + 1), %{}, fn w, cell ->
          Map.put(cell, w - 1, Enum.at(splits, h) |> String.at(w))
        end)

      Map.put(row, h - 1, column)
    end)
    |> Map.put("width", width)
    |> Map.put("height", height)
  end
end

{:ok, input} = File.read("./files/day_11_input.txt")
Advent.simulate(input, 4, &Advent.count_num_surrounding/3)
Advent.simulate(input, 5, &Advent.count_num_in_sight/3)
