defmodule Day02 do

  def part1 do
    File.stream!("inputs/day02.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({0, 0}, fn command, {position, depth} ->
      execute(command, position, depth)
    end)
    |> Tuple.product
  end

  def part2 do
    File.stream!("inputs/day02.txt")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce({0, 0, 0}, fn command, {position, depth, aim} ->
      execute2(command, position, depth, aim)
    end)
    |> then(fn {x, y, _} -> x*y end)
  end

  def execute("forward " <> val, position, depth) do
    v = String.to_integer(val)
    {position+v, depth}
  end

  def execute("down " <> val, position, depth) do
    v = String.to_integer(val)
    {position, depth + v}
  end

  def execute("up " <> val, position, depth) do
    v = String.to_integer(val)
    {position, depth - v}
  end

  def execute2("forward " <> val, position, depth, aim) do
    v = String.to_integer(val)
    {position+v, depth + aim*v, aim}
  end

  def execute2("down " <> val, position, depth, aim) do
    v = String.to_integer(val)
    {position, depth, aim+v}
  end

  def execute2("up " <> val, position, depth, aim) do
    v = String.to_integer(val)
    {position, depth, aim-v}
  end
end
