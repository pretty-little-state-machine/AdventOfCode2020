defmodule Advent do
  def part_1(input) do
    bag_rules = parse_input(input)

    [graph, verts] = run_digraph(bag_rules)
    count_num_paths_to_color(bag_rules, graph, verts, "shiny gold")
  end

  def part_2(input) do
    bag_rules = parse_input(input)
    sum_child_bags(1, bag_rules, "shiny gold") - 1
  end

  defp sum_child_bags(mul, bag_rules, bag_color) do
    cur_bag = Enum.find(bag_rules, fn x -> x.color == bag_color end)

    sum =
      Enum.reduce(cur_bag.holds, 1, fn x, a ->
        a + sum_child_bags(x.count, bag_rules, x.color)
      end)

    mul * sum
  end

  defp parse_input(input) do
    input
    |> String.replace("\r", "")
    |> String.split("\n")
    |> Enum.map(fn x -> parse_line(x) end)
  end

  defp parse_line(line) do
    color =
      line
      |> String.split(" bags")
      |> List.first()

    holds =
      line
      |> String.split("contain ")
      |> List.last()
      |> String.split(", ")
      |> extract_may_hold()

    %{color: color, holds: holds}
  end

  defp extract_may_hold(["no other bags."]) do
    []
  end

  defp extract_may_hold(list) do
    list
    |> Enum.map(fn x ->
      s = String.split(x)
      %{count: String.to_integer(List.first(s)), color: Enum.at(s, 1) <> " " <> Enum.at(s, 2)}
    end)
  end

  defp run_digraph(bag_rules) do
    g = :digraph.new()
    # Make a map of verts for fast-lookup later
    verts =
      bag_rules
      |> Enum.reduce(%{}, fn v, acc ->
        Map.put(acc, v.color, :digraph.add_vertex(g, v.color))
      end)

    # Edges
    bag_rules
    |> Enum.each(fn x ->
      x.holds
      |> Enum.each(fn h ->
        :digraph.add_edge(g, verts[x.color], verts[h.color], h.count)
      end)
    end)

    [g, verts]
  end

  defp count_num_paths_to_color(bag_rules, graph, verts, color) do
    bag_rules
    |> Enum.reduce(0, fn x, acc ->
      if has_path?(graph, verts[x.color], color) do
        acc + 1
      else
        acc
      end
    end)
  end

  defp has_path?(graph, v1, v2) do
    false != :digraph.get_short_path(graph, v1, v2)
  end
end

{:ok, input} = File.read("./files/day_07_input.txt")
part_1 = Advent.part_1(input)
IO.puts("Part 1: #{part_1}")

part_2 = Advent.part_2(input)
IO.puts("Part 2: #{part_2}")
