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

# UI mehtods for this game are considered those that contain puts, gets or print and their support methods
# support methods mean those that are only used whitin this module, so they under the private category
module UserInterface
  def draw_board(board)
    board = colorize_board(board)
    board.each_with_index do |row, i|
      row.each_with_index do |spot, j|
        print " #{spot} "
        print COLUMN_SEPARATOR if (0..1).include?(j)
      end
      puts ''
      puts ROW_SEPARATOR if (0..1).include?(i)
    end
    puts ''
  end

  def ask_for_player_input(player_number, board)
    verified_input = false
    until verified_input
      puts player_number.odd? ? 'Player 1:'.light_blue : 'Player 2:'.light_red
      ans = gets.strip.downcase
      verified_input = verify_input(ans, board)
      puts 'Please try again' unless verified_input
    end
    translate_input_to_index(ans, DICTIONARY)
  end

  def show_main_screen(board)
    puts 'Tic Tac Toe!'
    puts 'Two player mode'
    puts ''
    puts 'Playing is easy'
    puts 'This is the board:'
    draw_board(board)
    puts 'To make your move, just type any letter from a to i'
    puts ''
  end

  def say_tie
    puts "It's a tie".light_yellow
    puts ''
  end

  def say_player_wins(player_number)
    puts "Player #{player_number} wins".light_green
    puts ''
  end

  def say_error_message(error_code)
    case error_code
    when 1 then message = 'Game_result_error'
    end
    puts message
  end

  private

  def colorize_board(board)
    board.map do |line|
      line.map do |spot|
        spot = spot.light_black if DICTIONARY.keys.include?(spot)
        spot = spot.light_blue if spot == PLAYER_MARKS[0]
        spot = spot.light_red if spot == PLAYER_MARKS[1]
        spot
      end
    end
  end

  def verify_input(input, board)
    return false unless valid_input?(input, DICTIONARY)

    spot = translate_input_to_index(input, DICTIONARY)
    return false unless empty_spot?(board, spot)

    true
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

  def translate_input_to_index(player_input, dictionary)
    dictionary[player_input]
  end
end

# the TicTacToe class wraps the logic of the game
class TicTacToe
  include UserInterface

  def initialize
    @winner = false
    @tie = false
    @turn_count = 0
    @board_status = initialize_board
  end

  def play
    show_main_screen(@board_status)
    until @winner || @tie
      @turn_count += 1
      play_round(@board_status, @turn_count)
      @winner = winner?(@board_status)
      @tie = tie?(@turn_count, @winner)
    end
    game_result(@tie, @winner, @turn_count)
  end

  private

  def fill_board(board)
    current_char = 'a'.ord
    board.map do |line|
      line.map do
        spot = current_char.chr
        current_char += 1
        spot
      end
    end
  end

  def initialize_board
    new_board = Array.new(3, Array.new(3))
    fill_board(new_board)
  end

  def play_round(board_status, turn_count)
    mark = turn_count.odd? ? PLAYER_MARKS[0] : PLAYER_MARKS[1]
    board_status = update_board(board_status, mark, turn_count)
    draw_board(board_status)
    board_status
  end

  def update_board(board, mark, turn_count)
    player_input = ask_for_player_input(turn_count, board)
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

  def tie?(turn_count, winner)
    return false if winner
    return false if turn_count < 9

    true
  end

  def game_result(tie, winner, turn)
    if tie
      say_tie
    elsif winner
      turn.odd? ? say_player_wins(1) : say_player_wins(2)
    else
      say_error_message(1)
    end
  end
end

match = TicTacToe.new
match.play
