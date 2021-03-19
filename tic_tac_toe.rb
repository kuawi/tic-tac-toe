# frozen_string_literal: true

require 'colorize'

COLUMN_SEPARATOR = '|'
ROW_SEPARATOR = ' --------- '
DICTIONARY = { 'a' => [0, 0],
               'b' => [0, 1],
               'c' => [0, 2],
               'd' => [1, 0],
               'e' => [1, 1],
               'f' => [1, 2],
               'g' => [2, 0],
               'h' => [2, 1],
               'i' => [2, 2] }.freeze
PLAYER_MARKS = %w[o x].freeze

# the TicTacToe class wraps the logic and UI methods of this game
class TicTacToe
  def initialize
    @winner = false
    @tie = false
    @turn_count = 0
    @board_status = initialize_board
  end

  def play
    draw_board(@board_status)
    until @winner || @tie
      @turn_count += 1
      play_round(@board_status, @turn_count)
      @winner = winner?(@board_status)
      @tie = tie?(@turn_count)
    end
    puts game_result
  end

  private

  def fill_board(board)
    current_char = 'a'.ord
    board.map do |line|
      line.map do
        spot = current_char.chr
        spot = spot.light_black
        current_char += 1
        spot
      end
    end
  end

  def initialize_board
    new_board = Array.new(3, Array.new(3))
    fill_board(new_board)
  end

  def draw_board(board)
    board.each_with_index do |row, i|
      row.each_with_index do |spot, j|
        print " #{spot} "
        print COLUMN_SEPARATOR if (0..1).include?(j)
      end
      puts ''
      puts ROW_SEPARATOR if (0..1).include?(i)
    end
  end

  def play_round(board_status, turn_count)
    mark = turn_count.even? ? PLAYER_MARKS[0] : PLAYER_MARKS[1]
    board_status = update_board(board_status, mark, turn_count)
    draw_board(board_status)
    board_status
  end

  def translate_input_to_index(player_input, dictionary)
    dictionary[player_input]
  end

  def verify_input(input)
    return false unless valid_input?(input, DICTIONARY)

    spot = translate_input_to_index(input, DICTIONARY)
    return false unless empty_spot?(@board_status, spot)

    true
  end

  def ask_for_player_input(player_number)
    verified_input = false
    until verified_input
      puts "Player #{player_number.odd? ? 1 : 2}:"
      ans = gets.strip
      verified_input = verify_input(ans)
      puts "Please try again" unless verified_input
    end
    ans
  end

  def valid_input?(input, dictionary)
    return false if input.size > 1
    return false unless dictionary.keys.include?(input)

    true
  end

  def empty_spot?(board, spot)
    row = spot[0]
    column = spot[1]
    return false if PLAYER_MARKS.include?(board[row][column])

    true
  end

  def update_board(board, mark, turn_count)
    player_input = ask_for_player_input(turn_count)
    player_input = translate_input_to_index(player_input, DICTIONARY)
    board[player_input[0]][player_input[1]] = mark
    board
  end

  def winner?(board)
    return winner_in_rows?(board) if winner_in_rows?(board)
    return winner_in_columns?(board) if winner_in_columns?(board)
    return winner_in_diagonals?(board) if winner_in_diagonals?(board)

    false
  end

  def winner_in_rows?(board)
    board.each do |row|
      return true if row.uniq.size == 1
    end
    false
  end

  def winner_in_columns?(board)
    board = board.transpose
    winner_in_rows?(board)
  end

  def winner_in_diagonals?(board)
    return true if [board[0][0], board[1][1], board[2][2]].uniq.size == 1
    return true if [board[0][2], board[1][1], board[2][0]].uniq.size == 1

    false
  end

  def tie?(turn_count)
    return false if turn_count < 9

    true
  end

  def game_result
    return 'Tie' if @tie
    if @winner
      return @turn_count.odd? ? 'Player 1 Wins' : 'Player 2 Wins'
    end

    'game_result_error'
  end
end

match = TicTacToe.new
match.play
