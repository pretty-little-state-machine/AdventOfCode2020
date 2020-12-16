Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  # Public Interface
  def part_1(rules, near_tickets) do
    (collapse_tickets(near_tickets) -- collapse_rules(rules))
    |> Enum.sum()
  end

  def part_2(data) do
    valid_tickets = Enum.filter(data.nearby_tickets, fn t -> is_valid?(data.rules, t) end)

    cols =
      Enum.zip(valid_tickets)
      |> Enum.map(fn x -> %{vals: Tuple.to_list(x)} end)
      |> Enum.map(fn c ->
        Enum.reduce(data.rules, [], fn r, acc ->
          if matches_rule?(r, c.vals), do: acc ++ [r.name], else: acc
        end)
      end)
      |> Enum.sort_by(&Kernel.length/1)
      |> Z.debug()
  end

  defp is_valid?(rules, ticket) do
    r = collapse_rules(rules)

    Enum.all?(ticket, fn x ->
      x in r
    end)
  end

  defp matches_rule?(rule, list) do
    Enum.all?(list, fn x ->
      x in rule.vals
    end)
  end

  def parse_input(file) do
    [rules, your_ticket, near_tickets] =
      Z.file_to_list("files/day_16_input.txt")
      |> Z.chunk_filter_values("")

    %{
      rules: parse_rules(rules),
      your_ticket: parse_ticket(your_ticket) |> List.first(),
      nearby_tickets: parse_ticket(near_tickets)
    }
  end

  # Private Helpers
  defp parse_rules(list), do: Enum.map(list, fn x -> parse_rule(x) end)

  defp parse_ticket(input) do
    [_ | rest] = input
    rest |> Enum.map(fn x -> Z.map_integers(x, ",") end)
  end

  defp parse_rule(string) do
    [name, rest] = String.split(string, ": ")
    [first_range, last_range] = String.split(rest, " or ")
    v = build_inc_list(first_range) ++ build_inc_list(last_range)
    %{name: name, vals: v}
  end

  defp build_inc_list(range) do
    [first, last] = Z.map_integers(range, "-")
    for x <- first..last, into: [], do: x
  end

  defp collapse_tickets(tickets) do
    Enum.reduce(tickets, [], fn t, acc ->
      acc ++ t
    end)
  end

  defp collapse_rules(rules) do
    Enum.reduce(rules, [], fn x, acc ->
      acc ++ x.vals
    end)
  end
end

data = Advent.parse_input("files/day_16_input.txt")
# IO.puts("Part 1: #{Advent.part_1(data.rules, data.nearby_tickets)}")
Advent.part_2(data)
# Advent.parse_near_tickets(near_tickets) |> IO.inspect()
