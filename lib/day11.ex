defmodule AdventOfCode2019.Day11 do
  @moduledoc """
  Day 11 solutions
  """

  @doc """
  Solves the first riddle of day 11.

  ## Examples

      iex> File.read!("inputs/day11.txt") |> AdventOfCode2019.Day11.part1
      2041

  """
  def part1(program) do
    paint(start(program, 0), %{floor: %{}, direction: {-1, 0}, position: {0, 0}}) |> map_size()
  end

  @doc ~S"""
  Solves the second riddle of day 11.

  ## Examples

      iex> File.read!("inputs/day11.txt") |> AdventOfCode2019.Day11.part2
      "#### ###  #### ###  #  # #### #### ### \n   # #  #    # #  # # #  #       # #  #\n  #  #  #   #  #  # ##   ###    #  #  #\n #   ###   #   ###  # #  #     #   ### \n#    # #  #    #    # #  #    #    # # \n#### #  # #### #    #  # #### #### #  #"

  """
  def part2(program) do
    positions =
      paint(start(program, 1), %{floor: %{}, direction: {-1, 0}, position: {0, 0}})
      |> Enum.filter(fn {_, v} -> v == 1 end)
      |> Enum.map(fn {k, _} -> k end)

    {xs, xe} = positions |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
    {ys, ye} = positions |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()
    points = MapSet.new(positions)

    Enum.map_join(
      xs..xe,
      "\n",
      fn x ->
        Enum.map_join(ys..ye, &if(MapSet.member?(points, {x, &1}), do: "#", else: " "))
      end
    )
  end

  defp start(program, arg) do
    {{:input, continue}, []} =
      AdventOfCode2019.IntCode.parse(program)
      |> AdventOfCode2019.IntCode.run()

    continue.(arg)
  end

  defp paint({{:input, continue}, [color, direction]}, env) do
    floor = paint_floor(env, color)
    new_dir = {dx, dy} = rotate(env.direction, direction)
    {x, y} = env.position
    new_pos = {x + dx, y + dy}

    paint(continue.(Map.get(floor, new_pos, 0)), %{
      floor: floor,
      direction: new_dir,
      position: new_pos
    })
  end

  defp paint({:end, [color, _]}, env), do: paint_floor(env, color)

  defp paint_floor(env, color), do: Map.put(env.floor, env.position, color)

  defp rotate({x, y}, 0), do: {-y, x}
  defp rotate({x, y}, 1), do: {y, -x}
end
