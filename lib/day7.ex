defmodule AdventOfCode2019.Day7 do
  @moduledoc """
  Day 7 solutions
  """

  @doc """
  Solves the first riddle of day 7.

  ## Examples

      iex> AdventOfCode2019.Day7.part1("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0")
      43210
      iex> AdventOfCode2019.Day7.part1("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0")
      54321
      iex> AdventOfCode2019.Day7.part1("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0")
      65210
      iex> File.read!("inputs/day7.txt") |> AdventOfCode2019.Day7.part1
      13848

  """
  def part1(program) do
    parsed = AdventOfCode2019.IntCode.parse(program)
    permutations([0, 1, 2, 3, 4]) |> Enum.map(&amplify(&1, parsed, 0)) |> Enum.max()
  end

  @doc """
  Solves the second riddle of day 7.

  ## Examples

      iex> AdventOfCode2019.Day7.part2("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5")
      139629729
      iex> AdventOfCode2019.Day7.part2("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10")
      18216
      iex> File.read!("inputs/day7.txt") |> AdventOfCode2019.Day7.part2
      12932154

  """
  def part2(program) do
    parsed = AdventOfCode2019.IntCode.parse(program)

    permutations([5, 6, 7, 8, 9])
    |> Enum.map(fn permutation ->
      Enum.map(permutation, fn initial ->
        {{:input, continue}, []} = AdventOfCode2019.IntCode.run(parsed)
        {{:input, continue}, []} = continue.(initial)
        continue
      end)
      |> amplify_forever(0)
    end)
    |> Enum.max()
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for elem <- list, rest <- permutations(list -- [elem]), do: [elem | rest]
  end

  defp amplify([], _, strength), do: strength

  defp amplify([input | inputs], parsed, strength) do
    amplify(inputs, parsed, hd(AdventOfCode2019.IntCode.run(parsed, [input, strength])))
  end

  defp amplify_forever(amplifiers, strength) do
    {list, status} =
      Enum.map_reduce(amplifiers, {:running, strength}, fn continue, {_, strength} ->
        {continue_state, [out]} = continue.(strength)

        case continue_state do
          {:input, continue} -> {continue, {:running, out}}
          :end -> {:unreachable, {:ending, out}}
        end
      end)

    case status do
      {:running, out} -> amplify_forever(list, out)
      {:ending, out} -> out
    end
  end
end
