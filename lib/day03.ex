defmodule Day03 do
  def part1 do
    gama =
      File.stream!("inputs/day03.txt")
      |> Stream.map(&String.trim/1)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.zip
      |> Enum.map(&Tuple.to_list/1)
      |> Stream.map(&Enum.frequencies/1)
      |> Stream.map(&Enum.max_by(&1, fn { _, freq } -> freq end))
      |> Stream.map(&elem(&1, 0))

    epsilon = gama
              |> Enum.map(fn x -> 
                if x == "1" do
                  "0"
                else
                  "1"
                end
              end)

    gama_in_dec = gama |> Enum.join |> String.to_integer(2)
    epsilon_in_dec = epsilon |> Enum.join |> String.to_integer(2)

    gama_in_dec * epsilon_in_dec
  end

  def part2 do
    input = 
      "inputs/day03.txt"
      |> File.stream!
      |> Stream.map(&String.trim/1)
      |> Stream.map(&String.split(&1, "", trim: true))
      |> Stream.map(&List.to_tuple/1)

    oxygen_rating = input |> oxygen(0)
    co2_rating = input |> co2(0)

    oxygen_rating * co2_rating
  end

  def oxygen([ele], _) do
    to_i(ele)
  end

  def oxygen(list, pos) do
    groups =
      list
      |> Enum.group_by(&elem(&1, pos))

    %{"0" => group0, "1" => group1} = groups

    if length(group0) > length(group1) do
      oxygen(group0, pos+1)
    else
      oxygen(group1, pos+1)
    end
  end

  def co2([ele], _) do
    to_i(ele)
  end

  def co2(list, pos) do
    groups =
      list
      |> Enum.group_by(&elem(&1, pos))

    %{"0" => group0, "1" => group1} = groups

    if length(group0) > length(group1) do
      co2(group1, pos+1)
    else
      co2(group0, pos+1)
    end
  end

  def to_i(ele) do
    ele
    |> Tuple.to_list
    |> Enum.join("")
    |> String.to_integer(2)
  end
end
