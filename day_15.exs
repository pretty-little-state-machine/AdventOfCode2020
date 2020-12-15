input = %{l: 0, o: %{1 => 1, 0 => 2, 15 => 3, 2 => 4, 10 => 5, 13 => 6}}

result =
  Enum.reduce(7..(30_000_000 - 1), input, fn x, acc ->
    o = Map.get(acc.o, acc.l, 0)
    v = if(o == 0, do: 0, else: x - o)
    %{l: v, o: Map.put(acc.o, acc.l, x)}
  end)

IO.puts(result.l)
