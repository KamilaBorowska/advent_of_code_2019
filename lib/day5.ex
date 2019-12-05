defmodule AdventOfCode2019.Day5 do
  @moduledoc """
  Day 5 solutions
  """

  @doc """
  Solves the first riddle of day 5.

  ## Examples

      iex> AdventOfCode2019.Day5.part1("3,0,4,0,99")
      1
      iex> File.read!("inputs/day5.txt") |> AdventOfCode2019.Day5.part1
      9775037

  """
  def part1(program) do
    run_with_input(program, 1)
  end

  @doc """
  Solves the second riddle of day 5.

  ## Examples

      iex> AdventOfCode2019.Day5.part2("3,0,4,0,99")
      5
      iex> File.read!("inputs/day5.txt") |> AdventOfCode2019.Day5.part2
      15586959

  """
  def part2(program) do
    run_with_input(program, 5)
  end

  defp run_with_input(program, input) do
    [out] =
      run(%{mem: prog_mem(program), pc: 0, inputs: [input], outputs: []}).outputs
      |> Enum.filter(&(&1 != 0))

    out
  end

  defp prog_mem(program) do
    program
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  defp run(cpu) do
    fetch_opcode(cpu) |> run_opcode()
  end

  defp fetch_opcode(cpu) do
    {cpu, value} = fetch_pc(cpu)
    {flags, opcode} = divrem(value, 100)
    {cpu, opcode, flags}
  end

  defp run_opcode({cpu, opcode, flags}) do
    operation =
      case opcode do
        1 -> modify(&+/2)
        2 -> modify(&*/2)
        3 -> &take_input/2
        4 -> &store_output/2
        5 -> jump_if(&(&1 != 0))
        6 -> jump_if(&(&1 == 0))
        7 -> modify_bool(&</2)
        8 -> modify_bool(&==/2)
        99 -> fn cpu, 0 -> cpu end
      end

    operation.(cpu, flags)
  end

  defp modify(f) do
    fn cpu, flags ->
      {cpu, a, flags} = load(cpu, flags)
      {cpu, b, flags} = load(cpu, flags)
      {cpu, 0} = store(cpu, f.(a, b), flags)
      run(cpu)
    end
  end

  defp modify_bool(f) do
    modify(&if f.(&1, &2), do: 1, else: 0)
  end

  defp take_input(cpu, flags) do
    [input | rest] = cpu.inputs
    {cpu, 0} = store(cpu, input, flags)
    run(%{cpu | inputs: rest})
  end

  defp store_output(cpu, flags) do
    {cpu, value, 0} = load(cpu, flags)
    run(%{cpu | outputs: [value | cpu.outputs]})
  end

  defp jump_if(predicate) do
    fn cpu, flags ->
      {cpu, a, flags} = load(cpu, flags)
      {cpu, dst, 0} = load(cpu, flags)
      run(if predicate.(a), do: %{cpu | pc: dst}, else: cpu)
    end
  end

  defp load(cpu, flags) do
    {cpu, value} = fetch_pc(cpu)
    {rest, flag} = divrem(flags, 10)

    mem =
      case flag do
        0 -> :array.get(value, cpu.mem)
        1 -> value
      end

    {cpu, mem, rest}
  end

  defp store(cpu, value, flags) do
    {cpu, address} = fetch_pc(cpu)
    {rest, 0} = divrem(flags, 10)
    {%{cpu | mem: :array.set(address, value, cpu.mem)}, rest}
  end

  defp fetch_pc(cpu), do: {%{cpu | pc: cpu.pc + 1}, :array.get(cpu.pc, cpu.mem)}

  defp divrem(x, y), do: {div(x, y), rem(x, y)}
end
