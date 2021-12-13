defmodule Day01 do

  def part1 do
    File.stream!("inputs/day01.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(2, 1, :discard)
    # |> Stream.map(&IO.inspect/1)
    |> Enum.count(fn [x, y] -> x < y end)
  end

  def part2 do
    File.stream!("inputs/day01.txt")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(3, 1, :discard)
    # |> Stream.map(&IO.inspect/1)
    |> Stream.map(&Enum.sum/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [x, y] -> x < y end)
  end
end
