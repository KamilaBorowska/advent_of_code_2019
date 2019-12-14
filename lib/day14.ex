defmodule AdventOfCode2019.Day14 do
  @moduledoc """
  Day 14 solutions
  """

  @doc ~S"""
  Solves the first riddle of day 14.

  ## Examples

      iex> AdventOfCode2019.Day14.part1("10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL")
      31
      iex> AdventOfCode2019.Day14.part1("9 ORE => 2 A\n8 ORE => 3 B\n7 ORE => 5 C\n3 A, 4 B => 1 AB\n5 B, 7 C => 1 BC\n4 C, 1 A => 1 CA\n2 AB, 3 BC, 4 CA => 1 FUEL")
      165
      iex> File.read!("inputs/day14.txt") |> AdventOfCode2019.Day14.part1
      136771

  """
  def part1(grid) do
    String.trim(grid)
    |> String.split("\n")
    |> Enum.map(&parse_reaction(&1))
    |> to_map()
    |> ores(1)
  end

  @doc ~S"""
  Solves the second riddle of day 14.

  ## Examples

      iex> AdventOfCode2019.Day14.part2("157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT")
      82892753
      iex> File.read!("inputs/day14.txt") |> AdventOfCode2019.Day14.part2
      8193614

  """
  def part2(grid) do
    map =
      String.trim(grid)
      |> String.split("\n")
      |> Enum.map(&parse_reaction(&1))
      |> to_map()

    binary_search(map)
  end

  defp parse_reaction(line) do
    {count, <<" ", rest::binary>>} = Integer.parse(line)
    [name, sep, rest] = String.split(rest, ~r{, | => }, parts: 2, include_captures: true)

    case sep do
      ", " ->
        {inputs, output} = parse_reaction(rest)
        {[{count, name} | inputs], output}

      " => " ->
        {input_count, <<" ", input_name::binary>>} = Integer.parse(rest)
        {[{count, name}], {input_count, input_name}}
    end
  end

  defp to_map(reactions) do
    Map.new(reactions, fn {inputs, {count, name}} -> {name, {count, inputs}} end)
  end

  defp binary_search(map) do
    max =
      Stream.iterate(1, &(&1 * 2)) |> Enum.find(fn fuel -> not less_than_trillion(map, fuel) end)

    binary_search(map, div(max, 2), max)
  end

  defp binary_search(_, min, max) when min == max, do: max

  defp binary_search(map, min, max) do
    fuel = div(min + max, 2)

    if less_than_trillion(map, fuel),
      do: binary_search(map, fuel, max),
      else: binary_search(map, min, fuel - 1)
  end

  defp less_than_trillion(map, fuel), do: ores(map, fuel) <= 1_000_000_000_000

  defp ores(map, count) do
    {_, ores} = produce(map, [{"FUEL", count}], %{})
    ores
  end

  defp produce(map, [{"ORE", needed_quantity} | needs], store) do
    {store, ores} = produce(map, needs, store)
    {store, ores + needed_quantity}
  end

  defp produce(map, [need = {name, _} | needs], store) do
    {store, needed_quantity} = take_from_store(store, need)
    {production_quantity, ingredients} = map[name]
    production_units = div(needed_quantity + production_quantity - 1, production_quantity)
    ingredients = Enum.map(ingredients, fn {q, name} -> {name, q * production_units} end)
    {store, a_ores} = produce(map, ingredients, store)
    actual_quantity = production_units * production_quantity
    store = Map.update!(store, name, &(&1 + actual_quantity - needed_quantity))
    {store, b_ores} = produce(map, needs, store)
    {store, a_ores + b_ores}
  end

  defp produce(_, [], store), do: {store, 0}

  defp take_from_store(store, {name, needed_quantity}) do
    stored = Map.get(store, name, 0)
    taken = min(needed_quantity, stored)
    {Map.put(store, name, stored - taken), needed_quantity - taken}
  end
end
