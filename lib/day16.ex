defmodule AdventOfCode2019.Day16 do
  @moduledoc """
  Day 16 solutions
  """

  @doc """
  Solves the first riddle of day 16.

  ## Examples

      iex> AdventOfCode2019.Day16.part1("80871224585914546619083218645595")
      24176176
      iex> AdventOfCode2019.Day16.part1("19617804207202209144916044189917")
      73745418
      iex> AdventOfCode2019.Day16.part1("69317163492948606335995924319873")
      52432133
      iex> File.read!("inputs/day16.txt") |> AdventOfCode2019.Day16.part1()
      59281788

  """
  def part1(input) do
    input = String.trim(input) |> String.codepoints() |> Enum.map(&String.to_integer/1)

    Enum.reduce(1..100, input, fn _, input ->
      len = length(input)

      Enum.map(1..len, fn position ->
        Stream.cycle([0, 1, 0, -1])
        |> Stream.flat_map(&(Stream.repeatedly(fn -> &1 end) |> Stream.take(position)))
        |> Stream.drop(1)
        # If you use Stream.take here, you get incorrect result
        |> Enum.take(len)
        |> Enum.zip(input)
        |> Enum.map(fn {a, b} -> a * b end)
        |> Enum.sum()
        |> abs()
        |> rem(10)
      end)
    end)
    |> Enum.take(8)
    |> Enum.join()
    |> String.to_integer()
  end

  @doc """
  Solves the second riddle of day 16.

  ## Examples

      iex> AdventOfCode2019.Day16.part2("03036732577212944063491565474664")
      84462026
      iex> AdventOfCode2019.Day16.part2("02935109699940807407585447034323")
      78725270
      iex> AdventOfCode2019.Day16.part2("03081770884921959731165446850517")
      53553731
      iex> File.read!("inputs/day16.txt") |> AdventOfCode2019.Day16.part2()
      96062868

  """
  def part2(input) do
    input = String.trim(input)
    offset = String.slice(input, 0, 7) |> String.to_integer()
    input = String.codepoints(input) |> Enum.map(&String.to_integer/1)
    input_length = length(input) * 10_000
    # The multiplication matrix is upper triangular, which allows us to
    # optimize for the case when offset is in upper part of it. Reject
    # offsets below that, as they won't work with this method.
    true = input_length / 2 < offset

    suffix =
      Enum.reverse(input)
      |> Stream.cycle()
      |> Enum.take(input_length - offset)

    1..100
    |> Enum.reduce(suffix, fn _, suffix ->
      Enum.scan(suffix, 0, fn x, sum -> abs(sum + x) |> rem(10) end)
    end)
    |> Enum.take(-8)
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer()
  end
end
