defmodule AdventOfCode2019.Day1 do
  @moduledoc """
  Day 1 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 1. 

  ## Examples

      iex> AdventOfCode2019.Day1.part1("12")
      2
      iex> AdventOfCode2019.Day1.part1("14")
      2
      iex> AdventOfCode2019.Day1.part1("1969")
      654
      iex> AdventOfCode2019.Day1.part1("100756")
      33583
      iex> AdventOfCode2019.Day1.part1("12\n1969")
      656
      iex> File.read!("inputs/day1.txt") |> AdventOfCode2019.Day1.part1
      3342050

  """
  def part1(input) do
    lines(input) |> Enum.map(&fuel/1) |> Enum.sum()
  end

  @doc ~S"""
  Solves the second riddle of day 1. 

  ## Examples

      iex> AdventOfCode2019.Day1.part2("12")
      2
      iex> AdventOfCode2019.Day1.part2("14")
      2
      iex> AdventOfCode2019.Day1.part2("1969")
      966
      iex> AdventOfCode2019.Day1.part2("100756")
      50346
      iex> AdventOfCode2019.Day1.part2("12\n1969")
      968
      iex> File.read!("inputs/day1.txt") |> AdventOfCode2019.Day1.part2
      5010211

  """
  def part2(input) do
    lines(input) |> Enum.map(&recursive_fuel/1) |> Enum.sum()
  end

  defp lines(input) do
    input |> String.split("\n", trim: true) |> Enum.map(&String.to_integer/1)
  end

  defp fuel(mass) do
    max(div(mass, 3) - 2, 0)
  end

  defp recursive_fuel(mass) do
    fuel(mass) |> Stream.iterate(&fuel/1) |> Stream.take_while(&(&1 > 0)) |> Enum.sum()
  end
end
