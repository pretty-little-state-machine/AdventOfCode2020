defmodule Advent do
  @floor "."
  @filled "#"
  @empty "L"
  @max_runs 10_000

  def part_1(input) do
    layout = parse_input(input)

    steady_state =
      Enum.reduce_while(1..@max_runs, %{c: -1, l: layout}, fn _, acc ->
        new_layout = run_rules_part_1(acc.l)
        occupied = new_layout |> count_filled_seats()

        if acc.c != occupied do
          {:cont, %{c: occupied, l: new_layout}}
        else
          {:halt, %{c: occupied, l: new_layout}}
        end
      end)

    IO.puts("Steady state! - #{steady_state.c} seats filled")
    print_layout(steady_state.l)
  end

  defp run_rules_part_1(layout) do
    Enum.reduce(0..(layout["height"] - 1), %{}, fn r, r_acc ->
      cols =
        Enum.reduce(0..(layout["width"] - 1), %{}, fn c, c_acc ->
          num_filled = count_num_surrounding(layout, r, c)
          Map.put(c_acc, c, update_seat(layout[r][c], num_filled, 4))
        end)

      Map.put(r_acc, r, cols)
    end)
    |> Map.put("width", layout["width"])
    |> Map.put("height", layout["height"])
  end

  defp count_num_surrounding(layout, row, col) do
    n_val(layout, row - 1, col - 1) + n_val(layout, row - 1, col) +
      n_val(layout, row - 1, col + 1) + n_val(layout, row, col - 1) +
      n_val(layout, row, col + 1) + n_val(layout, row + 1, col - 1) +
      n_val(layout, row + 1, col) + n_val(layout, row + 1, col + 1)
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

  # Shared Logic - Parts 1 & 2
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

    Enum.reduce(0..(height - 1), %{}, fn h, row ->
      column =
        Enum.reduce(0..(width - 1), %{}, fn w, cell ->
          Map.put(cell, w, Enum.at(splits, h) |> String.at(w))
        end)

      Map.put(row, h, column)
    end)
    |> Map.put("width", width)
    |> Map.put("height", height)
  end
end

{:ok, input} = File.read("./files/day_11_input.txt")
Advent.part_1(input)
