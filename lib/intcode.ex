defmodule AdventOfCode2019.IntCode do
  def parse(program) do
    program
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> :array.from_list()
  end

  def run(mem), do: run_cpu(%{mem: mem, pc: 0, outputs: []})

  def run(mem, inputs) do
    {:end, outputs} =
      Enum.reduce(
        inputs,
        run(mem),
        fn input, out ->
          {:input, [], continue} = out
          continue.(input)
        end
      )

    outputs
  end

  defp run_cpu(cpu), do: fetch_opcode(cpu) |> run_opcode()

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
        99 -> fn cpu, 0 -> {:end, cpu.outputs} end
      end

    operation.(cpu, flags)
  end

  defp modify(f) do
    fn cpu, flags ->
      {cpu, a, flags} = load(cpu, flags)
      {cpu, b, flags} = load(cpu, flags)
      {cpu, 0} = store(cpu, f.(a, b), flags)
      run_cpu(cpu)
    end
  end

  defp modify_bool(f), do: modify(&if f.(&1, &2), do: 1, else: 0)

  defp take_input(cpu, flags) do
    {:input, cpu.outputs,
     fn input ->
       {cpu, 0} = store(cpu, input, flags)
       run_cpu(%{cpu | outputs: []})
     end}
  end

  defp store_output(cpu, flags) do
    {cpu, value, 0} = load(cpu, flags)
    run_cpu(%{cpu | outputs: [value | cpu.outputs]})
  end

  defp jump_if(predicate) do
    fn cpu, flags ->
      {cpu, a, flags} = load(cpu, flags)
      {cpu, dst, 0} = load(cpu, flags)
      run_cpu(if predicate.(a), do: %{cpu | pc: dst}, else: cpu)
    end
  end

  defp load(cpu, flags) do
    {cpu, value} = fetch_pc(cpu)
    {rest, flag} = divrem(flags, 10)

    value =
      case flag do
        0 -> :array.get(value, cpu.mem)
        1 -> value
      end

    {cpu, value, rest}
  end

  defp store(cpu, value, flags) do
    {cpu, address} = fetch_pc(cpu)
    {rest, 0} = divrem(flags, 10)
    {%{cpu | mem: :array.set(address, value, cpu.mem)}, rest}
  end

  defp fetch_pc(cpu), do: {%{cpu | pc: cpu.pc + 1}, :array.get(cpu.pc, cpu.mem)}

  defp divrem(x, y), do: {div(x, y), rem(x, y)}
end
