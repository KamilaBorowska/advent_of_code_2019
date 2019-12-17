defmodule AdventOfCode2019.Day17 do
  @moduledoc """
  Day 16 solutions
  """

  @doc """
  Solves the first riddle of day 17.

  ## Examples

      iex> File.read!("inputs/day17.txt") |> AdventOfCode2019.Day17.part1()
      1544

  """
  def part1(input) do
    AdventOfCode2019.IntCode.parse(input)
    |> AdventOfCode2019.IntCode.run([])
    |> :string.trim()
    |> :string.split('\n', :all)
    |> Enum.with_index()
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.flat_map(fn array = [_, {_, y}, _] ->
      Enum.map(array, fn {line, _} -> line end)
      |> Enum.zip()
      |> Enum.with_index()
      |> Enum.chunk_every(3, 1, :discard)
      |> Enum.filter(&match?([{{_, ?#, _}, _}, {{?#, ?#, ?#}, _}, {{_, ?#, _}, _}], &1))
      |> Enum.map(fn [_, {_, x}, _] -> x * y end)
    end)
    |> Enum.sum()
  end

  @doc """
  Solves the second riddle of day 17 (note that it's not generic, it only works for my input).

  ## Examples

      iex> File.read!("inputs/day17.txt") |> AdventOfCode2019.Day17.part2()
      696373

  """
  def part2(input) do
    {:end, out} =
      'A,B,A,B,C,A,B,C,A,C\nR,6,L,6,L,10\nL,8,L,6,L,10,L,6\nR,6,L,8,L,10,R,6\nn\n'
      |> Enum.reduce(
        AdventOfCode2019.IntCode.run(:array.set(0, 2, AdventOfCode2019.IntCode.parse(input))),
        fn byte, {{:input, continue}, _} -> continue.(byte) end
      )

    List.last(out)
  end
end
