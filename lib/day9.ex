defmodule AdventOfCode2019.Day9 do
  @moduledoc """
  Day 9 solutions
  """

  @doc """
  Solves the first riddle of day 9.

  ## Examples

      iex> File.read!("inputs/day9.txt") |> AdventOfCode2019.Day9.part1
      3512778005

  """
  def part1(program) do
    [out] = AdventOfCode2019.IntCode.parse(program) |> AdventOfCode2019.IntCode.run([1])
    out
  end

  @doc """
  Solves the second riddle of day 9.

  ## Examples

      iex> File.read!("inputs/day9.txt") |> AdventOfCode2019.Day9.part2
      35920

  """
  def part2(program) do
    [out] = AdventOfCode2019.IntCode.parse(program) |> AdventOfCode2019.IntCode.run([2])
    out
  end
end
