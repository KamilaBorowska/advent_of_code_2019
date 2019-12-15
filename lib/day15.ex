defmodule AdventOfCode2019.Day15 do
  @moduledoc """
  Day 15 solutions
  """

  @doc """
  Solves the first riddle of day 15.

  ## Examples

      iex> File.read!("inputs/day15.txt") |> AdventOfCode2019.Day15.part1()
      210

  """
  def part1(program) do
    {:input, [], continue} =
      AdventOfCode2019.IntCode.parse(program) |> AdventOfCode2019.IntCode.run()

    {steps, _} = search(continue)
    steps
  end

  @doc """
  Solves the second riddle of day 15.

  ## Examples

      iex> File.read!("inputs/day15.txt") |> AdventOfCode2019.Day15.part2()
      290

  """
  def part2(program) do
    {:input, [], continue} =
      AdventOfCode2019.IntCode.parse(program) |> AdventOfCode2019.IntCode.run()

    {_, continue} = search(continue)
    part2_search(:queue.from_list([{{0, 0}, 0, continue}]), MapSet.new([{0, 0}]), 0)
  end

  defp search(continue),
    do: search(:queue.from_list([{{0, 0}, 0, continue}]), MapSet.new([{0, 0}]))

  defp search(queue, set) do
    case run_search(queue, set) do
      {:oxygen, steps, continue} -> {steps, continue}
      {:move, _, queue, set} -> search(queue, set)
    end
  end

  defp part2_search(queue, set, steps) do
    case run_search(queue, set) do
      :empty -> steps
      {:move, steps, queue, set} -> part2_search(queue, set, steps)
    end
  end

  defp run_search(queue, set) do
    case :queue.out(queue) do
      {:empty, _} ->
        :empty

      {{:value, {position, steps, continue}}, queue} ->
        Enum.reduce_while(1..4, {:move, steps, queue, set}, fn input,
                                                               unmodified = {:move, _, queue, set} ->
          new_position = move_position(position, input)
          {:input, [droid_state], continue} = continue.(input)

          if MapSet.member?(set, new_position) do
            {:cont, unmodified}
          else
            case droid_state do
              0 ->
                {:cont, unmodified}

              1 ->
                queue = :queue.in({new_position, steps + 1, continue}, queue)
                set = MapSet.put(set, new_position)
                {:cont, {:move, steps, queue, set}}

              2 ->
                {:halt, {:oxygen, steps + 1, continue}}
            end
          end
        end)
    end
  end

  defp move_position({x, y}, input) do
    case input do
      1 -> {x, y - 1}
      2 -> {x, y + 1}
      3 -> {x - 1, y}
      4 -> {x + 1, y}
    end
  end
end
