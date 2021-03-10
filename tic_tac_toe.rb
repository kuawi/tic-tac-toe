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

def play_game
  winner = false
  turn_count = 0
  board_status = initialize_board
  draw_board(board_status)
  until winner
    play_round(board_status, turn_count)
    turn_count += 1
    winner = look_for_victory
  end
end

def play_round(board_status, turn_count)
  mark = turn_count.even? ? PLAYER_MARKS[0] : PLAYER_MARKS[1]
  board_status = update_board(board_status, mark)
  draw_board(board_status)
end

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

def translate_input_to_index(player_input, dictionary)
  dictionary[player_input]
end

def ask_for_player_input
  player_input = gets.strip
  translate_input_to_index(player_input, DICTIONARY)
end

def update_board(board, mark)
  player_input = ask_for_player_input
  board[player_input[0]][player_input[1]] = mark
  board
end

def look_for_victory
  true
end

play_game
