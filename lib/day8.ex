defmodule AdventOfCode2019.Day8 do
  @moduledoc """
  Day 8 solutions
  """

  @doc """
  Solves the first riddle of day 8.

  ## Examples

      iex> File.read!("inputs/day8.txt") |> AdventOfCode2019.Day8.part1
      1072

  """
  def part1(input) do
    min = decode_layers(input) |> Enum.min_by(fn image -> Enum.count(image, &(&1 == "0")) end)
    Enum.count(min, &(&1 == "1")) * Enum.count(min, &(&1 == "2"))
  end

  @doc """
  Solves the second riddle of day 8.

  ## Examples

  Note that this doesn't OCR, you are supposed to do it yourself

      iex> File.read!("inputs/day8.txt") |> AdventOfCode2019.Day8.part2
      "100011000011110111000011010001100001000010010000100101010000111001001000010001001000010000111000001000100100001000010000100100010011110100001000001100"

  """
  def part2(input) do
    decode_layers(input)
    |> Enum.zip()
    |> Enum.map_join(fn image -> Enum.find(Tuple.to_list(image), &(&1 != "2")) end)
  end

  defp decode_layers(input) do
    String.trim(input) |> String.codepoints() |> Enum.chunk_every(25 * 6)
  end
end
