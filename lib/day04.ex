require IEx

defmodule Day04 do
  def part1 do
    {numbers, boards, boards_mapping} = parse()

    Enum.reduce_while(numbers, boards, fn number, acc ->
      acc =
        acc
        |> Enum.with_index()
        |> Enum.map(fn {board, index} ->
          put_in_number(board, number, Enum.at(boards_mapping, index))
        end)

      case winning_board(acc) do
        [board] ->
          {:halt, score(board) * String.to_integer(number)}

        [] ->
          {:cont, acc}
      end
    end)
  end

  def part2 do
    {numbers, boards, boards_mapping} = parse()
    Enum.reduce(numbers, {boards, boards_mapping, []}, fn number, {acc, mapping, res} ->

      acc =
        acc
        |> Enum.with_index()
        |> Enum.map(fn {board, index} ->
          put_in_number(board, number, Enum.at(mapping, index))
        end)

      case winning_board(acc) do
        [] ->
          {acc, mapping, res}

        winning_boards ->
          winning_boards
          |> Enum.reduce({acc, mapping, res}, fn board, {acc, mapping, res} ->
            score = score(board) * String.to_integer(number)
            index = Enum.find_index(acc, fn x ->
              x == board
              end)
            acc = List.delete_at(acc, index)
            mapping = List.delete_at(mapping, index)
            res = res ++ [score]

            {acc, mapping, res}
          end)
      end
    end)
    |> elem(2)
    |> List.last
  end

  def put_in_number(board, number, mapping) do
    if Map.has_key?(mapping, number) do
      {x, y} = mapping[number]

      board
      |> Enum.with_index()
      |> Enum.map(fn {row, row_index} ->
        row
        |> Enum.with_index()
        |> Enum.map(fn {col, col_index} ->
          if x == row_index && y == col_index do
            "*#{col}"
          else
            col
          end
        end)
      end)
    else
      board
    end
  end

  def winning_board(boards) do
    Enum.filter(boards, &winning?/1)
  end

  def winning?(board) do
    check_winning_by_row(board) ||
      check_winning_by_col(board)
  end

  def check_winning_by_row(board) do
    Enum.any?(board, fn row ->
      Enum.all?(row, fn n ->
        String.starts_with?(n, "*")
      end)
    end)
  end

  def check_winning_by_col(board) do
    board
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.any?(fn row ->
      Enum.all?(row, fn n ->
        String.starts_with?(n, "*")
      end)
    end)
  end

  def score(board) do
    board
    |> Enum.map(fn row ->
      Enum.map(row, fn x ->
        case x do
          "*" <> _ -> 0
          n -> String.to_integer(n)
        end
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  def parse() do
    [numbers | raw_boards] =
      File.read!("inputs/day04.txt")
      |> String.split("\n", trim: true)

    boards =
      raw_boards
      |> Enum.chunk_every(5)
      |> Enum.map(&split_board/1)

    boards_mapping =
      boards
      |> Enum.map(&prepare_board_mapping/1)

    numbers = numbers |> String.split(",")

    {numbers, boards, boards_mapping}
  end

  def prepare_board_mapping(board) do
    board
    |> Enum.with_index()
    |> Enum.map(fn {row, row_index} ->
      row
      |> Enum.with_index()
      |> Enum.map(fn {number, col_index} ->
        {number, {row_index, col_index}}
      end)
    end)
    |> Enum.concat()
    |> Map.new()
  end

  def split_board(board) do
    board |> Enum.map(&String.split/1)
  end
end
