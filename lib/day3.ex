defmodule AdventOfCode2019.Day3 do
  @moduledoc """
  Day 3 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 3.

  ## Examples

      iex> AdventOfCode2019.Day3.part1("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      159
      iex> AdventOfCode2019.Day3.part1("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      135
      iex> File.read!("inputs/day3.txt") |> AdventOfCode2019.Day3.part1
      399

  """
  def part1(input) do
    generate_wires(input)
    |> Enum.map(&Map.keys/1)
    |> Enum.map(&MapSet.new/1)
    |> Enum.reduce(&MapSet.intersection/2)
    |> Enum.map(&manhattan_distance/1)
    |> Enum.min()
  end

  @doc ~S"""
  Solves the second riddle of day 3.

  ## Examples

      iex> AdventOfCode2019.Day3.part2("R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83")
      610
      iex> AdventOfCode2019.Day3.part2("R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7")
      410
      iex> File.read!("inputs/day3.txt") |> AdventOfCode2019.Day3.part2
      15678

  """
  def part2(input) do
    generate_wires(input) |> Enum.reduce(&map_intersect/2) |> Enum.min()
  end

  defp generate_wires(input) do
    input |> String.trim() |> String.split("\n") |> Enum.map(&gen_wires/1)
  end

  defp gen_wires(line) do
    {map, _, _} = line |> String.split(",") |> Enum.reduce({%{}, {0, 0}, 0}, &move/2)
    map
  end

  defp move(<<direction, count::binary>>, {visited, pos, distance}) do
    count = String.to_integer(count)
    np = &next_position(&1, direction, pos)
    new_visited = Enum.reduce(1..count, visited, &Map.put_new(&2, np.(&1), distance + &1))
    {new_visited, np.(count), distance + count}
  end

  defp next_position(count, direction, {x, y}) do
    case direction do
      ?U -> {x, y - count}
      ?D -> {x, y + count}
      ?L -> {x - count, y}
      ?R -> {x + count, y}
    end
  end

  defp manhattan_distance({x, y}), do: abs(x) + abs(y)

  defp map_intersect(a, b) do
    ak = Map.keys(a) |> MapSet.new()
    bk = Map.keys(b) |> MapSet.new()
    MapSet.intersection(ak, bk) |> Enum.map(&(Map.get(a, &1) + Map.get(b, &1)))
  end
end
