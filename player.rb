# frozen_string_literal: true

class Player
  attr_accessor :symbol
  attr_reader :name

  def initialize(name, board)
    @name = name
    @board = board
    @symbol = nil
    @num_of_draws = 0
  end

  def draw_symbol(location)
    @board.draw(location, @symbol)
    @num_of_draws += 1
  end

  def in_stalemate?
    @num_of_draws >= 4 && !full_line?
  end

  def full_line?
    @board.full_symbol_line?(@symbol)
  end

  def clear_stats
    @num_of_draws = 0
  end
end
