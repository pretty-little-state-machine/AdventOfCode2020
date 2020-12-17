defmodule ZoeysHelpers do
  @doc """
  Identical to IO.inspect()/1 with some useful flags set.
  """
  def debug(input) do
    IO.inspect(input, limit: :infinity, charlists: :aslist)
  end

  @doc """
  Reads in a file and returns a list of strings seperated by newlines.
  """
  def file_to_list(file) do
    {:ok, input} = File.read(file)

    input
    |> String.replace("\r", "")
    |> String.split("\n")
  end

  @doc """
  Takes a list of <T> and returns the number of values found.

  Example:
  a = [1, 2, 3, 2, 3, 4]
  num_in(a, 2)

  2
  """
  def num_in(input, value) do
    n = Enum.frequencies(input) |> Map.get(value)

    if n == nil, do: 0, else: n
  end

  @doc """
  Finds the index of the last occurance of an item in a list.

  Example:
  a = ["x","c","g","l","m", "l", "x"]
  rev_find_index(a, "l")

  5
  """
  def rev_find_index(input, value) do
    input |> Enum.reverse() |> Enum.find_index(value)
  end

  @doc """
  Converts a delimited string into a list of integers. The input
  string may also be the first value in another list.

  Example:
  a = "1,0,15,2,10,13"
  map_integers(a, ",")

  [1, 0, 15, 2, 10, 13]
  """
  def map_integers(input, delimiter) when Kernel.is_list(input) do
    input
    |> List.first()
    |> String.split(delimiter)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  def map_integers(input, delimiter) do
    input
    |> String.split(delimiter)
    |> Enum.map(fn x -> String.to_integer(x) end)
  end

  @doc """
  Returns a list of offsets from a list based on a filter function.

  Example:
  a = [1, 2, 4, 6, 11, 19, 31, 38]
  get_offsets(a, fn x -> rem(x, 2) == 0 end)

  [1, 2, 3, 7]
  """
  def get_offsets(list, filter_fn) do
    list
    |> Enum.with_index()
    |> Enum.filter(fn x ->
      {v, _} = x
      filter_fn.(v)
    end)
    |> Enum.map(fn x ->
      {_, idx} = x
      idx
    end)
  end

  @doc """
  Chunks a list on a given value and returns the number of entries
  in the child lists.

  Example:
  a = [1, 1, 3, 4, 3, 1, 1, 1, 3, 4, 1]
  count_chunk_values(a, 3)

  [2, 1, 3, 2]
  """
  def count_chunk_values(list, chunk_value) do
    list
    |> chunk_filter_values(chunk_value)
    |> Enum.map(fn x -> Kernel.length(x) end)
  end

  @doc """
  Chunks a list on a given value and returns the number of entries
  in the child lists.

  Example:
  a = [1, 1, 3, 4, 3, 1, 1, 1, 3, 4, 1]
  count_chunk_values(a, 3)

  [[1, 1], [4], [1, 1, 1], [4, 1]]
  """
  def chunk_filter_values(list, chunk_value) do
    list
    |> Enum.chunk_by(fn x -> x == chunk_value end)
    |> Enum.filter(fn x -> chunk_value not in x end)
  end

  @doc """
  Returns the exclusive-or of two operands.
  """
  def xor(a, b) when a == true and b == true, do: false
  def xor(a, b) when a == true and b == false, do: true
  def xor(a, b) when a == false and b == true, do: true
  def xor(_a, _b), do: false

  @doc """
  Returns the inverse-and of two operands.
  """
  def nand(a, b) when a == true and b == true, do: false
  def nand(a, b) when a == true and b == false, do: false
  def nand(a, b) when a == false and b == true, do: false
  def nand(_a, _b), do: true

  @doc """
  Returns the inverse-or of two operands.
  """
  def nor(a, b) when a == true and b == true, do: true
  def nor(a, b) when a == true and b == false, do: false
  def nor(a, b) when a == false and b == true, do: false
  def nor(_a, _b), do: true
end
