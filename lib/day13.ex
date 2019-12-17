defmodule AdventOfCode2019.Day13 do
  @moduledoc """
  Day 13 solutions
  """

  @doc """
  Solves the first riddle of day 13.

  ## Examples

      iex> File.read!("inputs/day13.txt") |> AdventOfCode2019.Day13.part1
      398

  """
  def part1(input) do
    AdventOfCode2019.IntCode.parse(input)
    |> AdventOfCode2019.IntCode.run([])
    |> render(%{})
    |> Map.values()
    |> Enum.count(&(&1 == 2))
  end

  @doc """
  Solves the first riddle of day 13.

  ## Examples

      iex> File.read!("inputs/day13.txt") |> AdventOfCode2019.Day13.part2
      19447

  """
  def part2(input) do
    :array.set(0, 2, AdventOfCode2019.IntCode.parse(input))
    |> AdventOfCode2019.IntCode.run()
    |> run_step(%{})
  end

  defp run_step({{:input, continue}, output}, map) do
    new_map = render(output, map)
    {{paddle_x, _}, _} = new_map |> Enum.find(fn {_, v} -> v == 3 end)
    # The ball can disappear, just put some arbitrary values and hope for the best
    {{ball_x, _}, _} = new_map |> Enum.find({{0, nil}, nil}, fn {_, v} -> v == 4 end)
    sign(ball_x, paddle_x) |> continue.() |> run_step(new_map)
  end

  defp run_step({:end, output}, map), do: render(output, map)[{-1, 0}]

  defp render(output, map) do
    Enum.chunk_every(output, 3)
    |> Enum.reduce(map, fn [x, y, tile], map -> Map.put(map, {x, y}, tile) end)
  end

  defp sign(a, b) do
    cond do
      a > b -> 1
      a == b -> 0
      a < b -> -1
    end
  end
end
