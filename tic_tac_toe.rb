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

def play
  winner = false
  board = initialize_board
  draw_board(board)
  until winner
    board = update_board(board)
    draw_board(board)
    winner = look_for_victory
  end
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

def translate_input_to_index(input, dictionary)
  dictionary[input]
end

def ask_for_player_input
  player_input = gets.strip
  translate_input_to_index(player_input, DICTIONARY)
end

def update_board(board)
  player_input = ask_for_player_input
  board[player_input[0]][player_input[1]] = 'x'
  board
end

def look_for_victory
  true
end

play
