defmodule AdventOfCode2019.Day5 do
  @moduledoc """
  Day 5 solutions
  """

  @doc """
  Solves the first riddle of day 5.

  ## Examples

      iex> AdventOfCode2019.Day5.part1("3,0,4,0,99")
      1
      iex> File.read!("inputs/day5.txt") |> AdventOfCode2019.Day5.part1
      9775037

  """
  def part1(program), do: run(program, 1)

  @doc """
  Solves the second riddle of day 5.

  ## Examples

      iex> AdventOfCode2019.Day5.part2("3,0,4,0,99")
      5
      iex> File.read!("inputs/day5.txt") |> AdventOfCode2019.Day5.part2
      15586959

  """
  def part2(program), do: run(program, 5)

  defp run(program, input) do
    AdventOfCode2019.IntCode.parse(program)
    |> AdventOfCode2019.IntCode.run([input])
    |> diagnostic()
  end

  defp diagnostic(outputs) do
    [d] = Enum.filter(outputs, &(&1 != 0))
    d
  end
end
