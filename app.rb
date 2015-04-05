require_relative 'config/environment'
require 'sinatra'

class Sudoku
  attr_reader :board
  def initialize(str)
    @str = str.split("")
    @board = []
  end

  def board
    @str.each_with_index do |x,i|
      if x.to_i != 0
        @board[i] = x.to_i
      else
        @board[i] = 0
      end
    end
    @board
  end

  def col_index(board_index)
    board_index / 9
  end

  def row_index(board_index)
      board_index % 9
  end

  def box_index(board_index)
      (col_index(board_index)/3) + (row_index(board_index) * 1 / 3 * 3)
  end


  def col(board, colindex)
    col = []
    board
    board.each_with_index do |x, i|
      if col_index(i) == colindex
        col << x
      end
    end
    col
  end

  def row(board, colindex)
    row = []
    board
    board.each_with_index do |x, i|
      if row_index(i) == colindex
        row << x
      end
    end
    row
  end

  def box(board, colindex)
    box = []
    board
    board.each_with_index do |x, i|
      if box_index(i) == colindex
        box << x
      end
    end
    box
  end

  def possible_guesses(board, index)
      if board[index] == 0
        numbers = [*1..9]
        possibles = numbers - box(board, box_index(index)) - row(board, row_index(index)) - col(board, col_index(index))
      else
         possibles = []
      end
      possibles
  end

  def print_each_possible(board)
    new_array =[]
    board.each_with_index do |x, i|
      if possible_guesses(board, i).length > 0
      new_array << possible_guesses(board ,i)
      end
    end
    new_array
  end

  def logical_guesses(board)
    81.times do
      board.each_with_index do |x, i|
        today = possible_guesses(board, i)
        if today.length == 1
          board[i] = today[0]
        end
      end
  end
  board
  end

  def logical_guesses?(board)
    any = 0
    board.each_with_index do |x, i|
      if possible_guesses(board, i).length == 1
        any += 1
      end
    end
    if any > 0
      true
    else
      false
    end
  end

  def solver
    board
    logical_guesses(@board)
    1000000.times do
      store = Array.new
      store = @board.dup
      while possible_guesses?(store)
        fill_in(store, 3)
        fill_in(store, 4)
      end
      if store.include?(0) == false
        store
        return store
      else
        store = store.clear
      end
  end
end

def answer
  solver
end

  def fill_in(board, number)
      board.each_with_index do |x, i|
      if logical_guesses?(board)
        logical_guesses(board)
      end
      tester = possible_guesses(board, i)
      if tester.length < number && tester.length > 0
        board[i] = tester.sample
      end
    end
  end

  def possible_guesses?(board)
    if print_each_possible(board).flatten.empty? == false
        return true
      end
    false
  end

  def original_board(board)
    i = 0
    puts "The original puzzle:"
    while i < 9
      puts col(board, i).join("  ")
      i += 1
    end
  end

  def sorting_boards(board)
    i = 0
    puts "We are testing for the solution. Here is the current test board:"
    while i < 9
      puts col(board, i).join("  ")
      i += 1
    end
  end

  def final_board(board)
    i = 0
    puts "And, the winning board:"
    while i < 9
      puts col(board, i).join("  ")
      i += 1
    end
  end
end


get '/' do
  erb :form
  # 'hello'
end


post '/form' do
  string = ''
  i = 0
  while i < 81
    if params["#{:cell}""#{i}"].to_i != 0
        add = params["#{:cell}""#{i}"]
        string += add
    else
      add = '-'
      string += add
    end
   i += 1
  end
  sud = Sudoku.new(string)
  sud.board
  @a = sud.answer
  i = 0
  j = 8
  @b = []
  while j < 81
    @b << @a[i..j]
    i += 9
    j += 9
  end
  erb :answer
end

get '/form' do
  @b
  erb :answer
  # 'hello'
end
