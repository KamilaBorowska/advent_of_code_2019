defmodule AdventOfCode2019.Day19 do
  @moduledoc """
  Day 19 solutions
  """

  @doc """
  Solves the first riddle of day 19.

  ## Examples

      iex> File.read!("inputs/day19.txt") |> AdventOfCode2019.Day19.part1()
      201

  """
  def part1(input) do
    continue = start(input)
    for(x <- 0..49, y <- 0..49, do: at_pos({x, y}, continue)) |> Enum.count(& &1)
  end

  @doc """
  Solves the second riddle of day 19.

  ## Examples

      iex> File.read!("inputs/day19.txt") |> AdventOfCode2019.Day19.part2()
      6610984

  """
  def part2(input) do
    continue = start(input)

    {x, y} =
      for(x <- 0..49, y <- 0..49, do: {x, y})
      |> Enum.filter(&at_pos(&1, continue))
      |> Enum.max()
      |> search(continue)

    x * 10000 + y
  end

  defp start(input) do
    {{:input, continue}, []} =
      AdventOfCode2019.IntCode.parse(input) |> AdventOfCode2019.IntCode.run()

    continue
  end

  defp search({x, y}, continue) do
    cond do
      x >= 99 && at_pos({x - 99, y + 99}, continue) -> {x - 99, y}
      at_pos({x + 1, y}, continue) -> search({x + 1, y}, continue)
      true -> search({x, y + 1}, continue)
    end
  end

  defp at_pos({x, y}, continue) do
    {{:input, continue}, []} = continue.(x)
    {:end, [value]} = continue.(y)

    case value do
      0 -> false
      1 -> true
    end
  end
end
