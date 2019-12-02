defmodule AdventOfCode2019.Day2 do
  @moduledoc """
  Day 2 solutions
  """

  @doc """
  Solves the first riddle of day 2.

  ## Examples

      iex> File.read!("inputs/day2.txt") |> AdventOfCode2019.Day2.part1
      5110675

  """
  def part1(input) do
    input |> prog_mem() |> interpreter(12, 2)
  end

  @doc """
  Solves the second riddle of day 2.

  ## Examples

      iex> File.read!("inputs/day2.txt") |> AdventOfCode2019.Day2.part2
      4847

  """
  def part2(input) do
    mem = prog_mem(input)

    {noun, verb, _} =
      for noun <- 0..99, verb <- 0..99 do
        {noun, verb, interpreter(mem, noun, verb)}
      end
      |> Enum.find(fn {_, _, value} -> value == 1969_07_20 end)

    noun * 100 + verb
  end

  defp prog_mem(input) do
    input
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  defp interpreter(mem, noun, verb) do
    mem |> set_values(noun, verb) |> run_interpreter(0) |> first_elem()
  end

  defp set_values(mem, noun, verb) do
    :array.set(2, verb, :array.set(1, noun, mem))
  end

  defp run_interpreter(mem, pos) do
    [opcode, a_ptr, b_ptr, dest] = extract_params(mem, pos)

    modify = fn f ->
      a = :array.get(a_ptr, mem)
      b = :array.get(b_ptr, mem)
      run_interpreter(:array.set(dest, f.(a, b), mem), pos + 4)
    end

    case opcode do
      1 -> modify.(&+/2)
      2 -> modify.(&*/2)
      99 -> mem
    end
  end

  defp extract_params(mem, pos) do
    0..3 |> Enum.map(&:array.get(pos + &1, mem))
  end

  defp first_elem(mem) do
    :array.get(0, mem)
  end
end
