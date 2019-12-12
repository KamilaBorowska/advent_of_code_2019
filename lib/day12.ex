defmodule AdventOfCode2019.Day12 do
  @moduledoc """
  Day 12 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 12.

  ## Examples

      iex> AdventOfCode2019.Day12.part1("<x=3, y=-6, z=6>\n<x=10, y=7, z=-9>\n<x=-3, y=-7, z=9>\n<x=-8, y=0, z=4>")
      6849

  """
  def part1(input) do
    1..1000
    |> Enum.reduce(parse_planets(input), fn _, planets -> Enum.map(planets, &run_step/1) end)
    |> Enum.map(fn arg -> Enum.map(arg, &Tuple.to_list/1) end)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn planet ->
      [a, b] =
        Enum.zip(planet)
        |> Enum.map(fn tuple -> Tuple.to_list(tuple) |> Enum.map(&abs/1) |> Enum.sum() end)

      a * b
    end)
    |> Enum.sum()
  end

  @doc ~S"""
  Solves the second riddle of day 12.

  ## Examples

      iex> AdventOfCode2019.Day12.part2("<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>")
      2772
      iex> AdventOfCode2019.Day12.part2("<x=3, y=-6, z=6>\n<x=10, y=7, z=-9>\n<x=-3, y=-7, z=9>\n<x=-8, y=0, z=4>")
      356658899375688

  """
  def part2(input) do
    parse_planets(input)
    |> Enum.map(fn coordinate ->
      Stream.iterate(coordinate, &run_step/1)
      |> Stream.drop(1)
      |> Stream.take_while(&(&1 != coordinate))
      |> Enum.count()
      |> Kernel.+(1)
    end)
    |> Enum.reduce(1, &lcm/2)
  end

  defp parse_planets(input) do
    String.trim(input)
    |> String.split("\n")
    |> Enum.map(&parse_planet/1)
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(fn list -> Enum.map(list, &{&1, 0}) end)
  end

  defp parse_planet(<<"<x=", rest::binary>>) do
    {x, <<", y=", rest::binary>>} = Integer.parse(rest)
    {y, <<", z=", rest::binary>>} = Integer.parse(rest)
    {z, ">"} = Integer.parse(rest)
    [x, y, z]
  end

  defp run_step(coordinate), do: update_coordinate(coordinate) |> add_velocity()

  defp update_coordinate(coordinate) do
    Enum.map(coordinate, fn planet ->
      Enum.reduce(coordinate, planet, fn {b, _}, {a, v} -> {a, v + sign(b, a)} end)
    end)
  end

  defp add_velocity(coordinate), do: Enum.map(coordinate, fn {a, v} -> {a + v, v} end)

  defp sign(a, b) do
    cond do
      a > b -> 1
      a == b -> 0
      a < b -> -1
    end
  end

  defp lcm(a, b), do: div(a * b, Integer.gcd(a, b))
end
