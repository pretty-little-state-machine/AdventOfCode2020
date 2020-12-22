Code.require_file("zoeys_helpers.exs")
alias ZoeysHelpers, as: Z

defmodule Advent do
  def part_1() do
    {p1_deck, p2_deck} = parse("files/day_22_input.txt")

    play_space_cards(p1_deck, p2_deck)
  end

  def part_2() do
    {p1_deck, p2_deck} = parse("files/day_22_input.txt")

    play_recursive_combat(p1_deck, p2_deck)
  end

  # Recursive recursiv recu com comba combat!
  defp play_recursive_combat(p1_deck, p2_deck, prev_hands \\ [])

  defp play_recursive_combat(p1_deck, p2_deck, _) when Kernel.length(p1_deck) == 0,
    do: finish_game(p1_deck, p2_deck)

  defp play_recursive_combat(p1_deck, p2_deck, _) when Kernel.length(p2_deck) == 0,
    do: finish_game(p1_deck, p2_deck)

  defp play_recursive_combat(p1_deck, p2_deck, prev_hands) do
    {p1_deck, p2_deck} =
      if repeat_play?(p1_deck, p2_deck, prev_hands) do
        IO.puts("Instant win for Player 1!")
        play_recursive_combat(p1_deck, [], [])
      else
        {p1_card, p1_deck} = draw_card(p1_deck)
        {p2_card, p2_deck} = draw_card(p2_deck)

        if p1_card <= Kernel.length(p1_deck) and p2_card <= Kernel.length(p2_deck) do
          IO.puts("~RECURSIVE COMBAT~")

          {_p1_subdeck, p2_subdeck} =
            play_recursive_combat(Enum.take(p1_deck, p1_card), Enum.take(p2_deck, p2_card), [])

          if p2_subdeck == [] do
            {p1_deck ++ [p1_card, p2_card], p2_deck}
          else
            {p1_deck, p2_deck ++ [p2_card, p1_card]}
          end
        else
          # Normal Rules
          if p1_card > p2_card do
            {p1_deck ++ [p1_card, p2_card], p2_deck}
          else
            {p1_deck, p2_deck ++ [p2_card, p1_card]}
          end
        end
      end

    play_recursive_combat(p1_deck, p2_deck, prev_hands ++ [{p1_deck, p2_deck}])
  end

  defp repeat_play?(deck_1, deck_2, prev_hands) do
    count =
      Enum.map(prev_hands, fn {prev_d1, prev_d2} ->
        deck_1 === prev_d1 and deck_2 === prev_d2
      end)
      |> Enum.filter(fn x -> x == true end)
      |> Enum.count()

    count >= 2
  end

  # Spaaaaaace Caaaaaaaards!
  defp play_space_cards(p1_deck, p2_deck) when Kernel.length(p1_deck) == 0,
    do: finish_game(p1_deck, p2_deck)

  defp play_space_cards(p1_deck, p2_deck) when Kernel.length(p2_deck) == 0,
    do: finish_game(p1_deck, p2_deck)

  defp play_space_cards(p1_deck, p2_deck) do
    {p1_card, p1_deck} = draw_card(p1_deck)
    {p2_card, p2_deck} = draw_card(p2_deck)

    {p1_deck, p2_deck} =
      if p1_card > p2_card do
        {p1_deck ++ [p1_card, p2_card], p2_deck}
      else
        {p1_deck, p2_deck ++ [p2_card, p1_card]}
      end

    play_space_cards(p1_deck, p2_deck)
  end

  # Game Helpers
  defp draw_card(deck), do: List.pop_at(deck, 0)

  defp calc_score(deck) do
    deck
    |> Enum.reverse()
    |> Stream.with_index(1)
    |> Enum.reduce(0, fn {card, value}, acc -> acc + card * value end)
  end

  defp finish_game(p1_deck, p2_deck) do
    IO.write("Game is over! Player ")

    score =
      if p2_deck == [] do
        IO.puts("1 wins!")
        calc_score(p1_deck)
      else
        IO.puts("2 wins!")
        calc_score(p2_deck)
      end

    IO.puts("Score: #{score}")
    {p1_deck, p2_deck}
  end

  # Boring file stuff
  defp parse(file) do
    [p1_deck, p2_deck] =
      Z.file_to_list(file)
      |> Z.stream_chunk_filter_values("")
      |> Stream.map(&Stream.drop(&1, 1))
      |> Enum.map(&parse_cards/1)

    {p1_deck, p2_deck}
  end

  defp parse_cards(list), do: Enum.map(list, &String.to_integer(&1))
end

# IO.puts("Part 1: #{Advent.part_1()}")
Advent.part_2()
