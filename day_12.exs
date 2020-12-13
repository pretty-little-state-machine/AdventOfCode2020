defmodule Advent do
  def get_manhattan(%{x: x, y: y}) do
    abs(x) + abs(y)
  end

  def parse_input(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn x ->
      {first, rest} = String.graphemes(x) |> List.pop_at(0)
      %{action: first, value: Enum.join(rest) |> String.to_integer()}
    end)
  end
end

defmodule Part1 do
  def run(actions) do
    ship = %{x: 0, y: 0, h: 90}

    Enum.reduce(actions, ship, fn x, acc -> action(x, acc) end)
    |> Advent.get_manhattan()
  end

  def action(%{action: "F", value: v}, ship = %{h: 0}),
    do: Map.put(ship, :y, ship[:y] + v)

  def action(%{action: "F", value: v}, ship = %{h: 90}),
    do: Map.put(ship, :x, ship[:x] + v)

  def action(%{action: "F", value: v}, ship = %{h: 180}),
    do: Map.put(ship, :y, ship[:y] - v)

  def action(%{action: "F", value: v}, ship = %{h: 270}),
    do: Map.put(ship, :x, ship[:x] - v)

  def action(%{action: "R", value: v}, ship),
    do: Map.put(ship, :h, adjust_heading(ship[:h], v, "R"))

  def action(%{action: "L", value: v}, ship),
    do: Map.put(ship, :h, adjust_heading(ship[:h], v, "L"))

  def action(%{action: "N", value: v}, ship),
    do: Map.put(ship, :y, ship[:y] + v)

  def action(%{action: "S", value: v}, ship),
    do: Map.put(ship, :y, ship[:y] - v)

  def action(%{action: "E", value: v}, ship),
    do: Map.put(ship, :x, ship[:x] + v)

  def action(%{action: "W", value: v}, ship),
    do: Map.put(ship, :x, ship[:x] - v)

  def action(_, ship), do: ship

  def adjust_heading(a, b, "R") do
    x = a + b
    if x >= 360, do: x - 360, else: x
  end

  def adjust_heading(a, b, "L") do
    x = a - b
    if x < 0, do: 360 + x, else: x
  end

  def adjust_heading(a, _, _), do: a
end

defmodule Part2 do
  def run(actions) do
    ship = %{x: 0, y: 0}
    waypoint = %{x: -1, y: 10}

    r =
      Enum.reduce(actions, %{s: ship, w: waypoint}, fn x, acc ->
        action(x, acc)
      end)

    Advent.get_manhattan(r.s)
  end

  defp action(%{action: "F", value: v}, %{s: s, w: w}) do
    new_ship = %{x: s[:x] + v * w[:x], y: s[:y] + v * w[:y]}
    %{s: new_ship, w: w}
  end

  defp action(%{action: "R", value: v}, %{s: s, w: w}) do
    r = 3.141592 * -v / 180
    x = (w[:x] * :math.cos(r) - w[:y] * :math.sin(r)) |> round()
    y = (w[:x] * :math.sin(r) + w[:y] * :math.cos(r)) |> round()
    %{s: s, w: %{x: x, y: y}}
  end

  defp action(%{action: "L", value: v}, %{s: s, w: w}) do
    r = 3.141592 * v / 180
    x = (w[:x] * :math.cos(r) - w[:y] * :math.sin(r)) |> round()
    y = (w[:x] * :math.sin(r) + w[:y] * :math.cos(r)) |> round()
    %{s: s, w: %{x: x, y: y}}
  end

  defp action(%{action: "N", value: v}, %{s: s, w: w}),
    do: %{s: s, w: Map.put(w, :x, w[:x] - v)}

  defp action(%{action: "S", value: v}, %{s: s, w: w}),
    do: %{s: s, w: Map.put(w, :x, w[:x] + v)}

  defp action(%{action: "E", value: v}, %{s: s, w: w}),
    do: %{s: s, w: Map.put(w, :y, w[:y] + v)}

  defp action(%{action: "W", value: v}, %{s: s, w: w}),
    do: %{s: s, w: Map.put(w, :y, w[:y] - v)}

  defp action(_, x), do: x
end

{:ok, input} = File.read("./files/day_12_input.txt")
i = Advent.parse_input(input)
p1 = Part1.run(i)
IO.puts("Part 1: #{p1}")

p2 = Advent.parse_input(input) |> Part2.run()
IO.puts("Part 2: #{p2}")
