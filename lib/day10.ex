defmodule AdventOfCode2019.Day10 do
  @moduledoc """
  Day 10 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 10.

  ## Examples

      iex> AdventOfCode2019.Day10.part1(".#..#\n.....\n#####\n....#\n...##")
      8
      iex> AdventOfCode2019.Day10.part1("......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####")
      33
      iex> AdventOfCode2019.Day10.part1("#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###.")
      35
      iex> File.read!("inputs/day10.txt") |> AdventOfCode2019.Day10.part1
      214

  """
  def part1(grid) do
    parsed = parse_grid(grid)
    map = MapSet.new(parsed)
    parsed |> Enum.map(&count_asteroids(&1, parsed, map)) |> Enum.max()
  end

  @doc ~S"""
  Solves the second riddle of day 10.

  ## Examples

      iex> File.read!("inputs/day10_largeexample.txt") |> AdventOfCode2019.Day10.part2
      802
      iex> File.read!("inputs/day10.txt") |> AdventOfCode2019.Day10.part2
      502

  """
  def part2(grid) do
    parsed = parse_grid(grid)
    map = MapSet.new(parsed)
    max_pos = {x1, y1} = Enum.max_by(parsed, &count_asteroids(&1, parsed, map))

    {x, y} =
      Enum.filter(parsed, &in_sight?(max_pos, &1, map))
      |> Enum.sort_by(fn {x2, y2} ->
        v = :math.atan2(x2 - x1, y2 - y1)
        {v < 0, -v}
      end)
      |> Enum.fetch!(200 - 1)

    x * 100 + y
  end

  defp parse_grid(grid) do
    for {line, x} <- String.split(grid, "\n") |> Enum.with_index(),
        {c, y} <- String.codepoints(line) |> Enum.with_index(),
        c == "#",
        do: {y, x}
  end

  defp count_asteroids(point, parsed, map), do: Enum.count(parsed, &in_sight?(point, &1, map))

  defp in_sight?(a, b, _) when a == b, do: false

  defp in_sight?({x1, y1}, dest = {x2, y2}, map) do
    {xm, ym} = fraction(x2 - x1, y2 - y1)
    new_pos = {x1 + xm, y1 + ym}
    new_pos == dest || (!MapSet.member?(map, new_pos) && in_sight?(new_pos, dest, map))
  end

  defp fraction(a, b) do
    gcd = Integer.gcd(a, b)
    {div(a, gcd), div(b, gcd)}
  end
end
