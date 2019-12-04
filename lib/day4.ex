defmodule AdventOfCode2019.Day4 do
  @moduledoc """
  Day 4 solutions
  """

  @doc """
  Solves the first riddle of day 4.

  ## Examples

      iex> AdventOfCode2019.Day4.part1("138241-674034")
      1890

  """
  def part1(input) do
    parse_range(input)
    |> Stream.map(&Stream.chunk_every(&1, 2, 1, :discard))
    |> Stream.filter(&two_adjacent_digits?/1)
    |> Enum.count(&incrementing?/1)
  end

  @doc """
  Solves the second riddle of day 4.

  ## Examples

      iex> AdventOfCode2019.Day4.part2("138241-674034")
      1277

  """
  def part2(input) do
    parse_range(input)
    |> Stream.filter(&strictly_two_adjacent_digits?/1)
    |> Stream.map(&Stream.chunk_every(&1, 2, 1, :discard))
    |> Enum.count(&incrementing?/1)
  end

  defp parse_range(input) do
    [from, to] = input |> String.trim() |> String.split("-") |> Enum.map(&String.to_integer/1)
    from..to |> Stream.map(&Integer.to_string/1) |> Stream.map(&String.codepoints/1)
  end

  defp two_adjacent_digits?(chunks) do
    Enum.any?(chunks, fn [a, b] -> a == b end)
  end

  defp incrementing?(chunks) do
    Enum.all?(chunks, fn [a, b] -> a <= b end)
  end

  def strictly_two_adjacent_digits?(codepoints) do
    Enum.chunk_every([:ignore | codepoints], 4, 1)
    |> Enum.any?(fn [a, b, c | d] -> a != b && b == c && [c] != d end)
  end
end
