# frozen_string_literal: true

require './player'
require './board'

class Game
  attr_accessor :p1, :p2, :board

  def initialize
    p1_name = ask_p1_name
    p2_name = ask_p2_name

    p1_symbol = ask_p1_symbol(p1_name)
    p2_symbol = p1_symbol == 'o' ? 'x' : 'o'
    puts "Second player (#{p2_name}) was assigned #{p2_symbol}!"

    @p1 = Player.new(p1_name, p1_symbol)
    @p2 = Player.new(p2_name, p2_symbol)

    @board = Board.new
  end

  private

  def ask_p1_name
    puts 'First player\'s name:'
    gets.chomp.strip
  end

  def ask_p2_name
    puts 'Second player\'s name:'
    gets.chomp.strip
  end

  def ask_p1_symbol(name)
    puts "First player (#{name})'s symbol choice (x or o):"
    choice = gets.chomp.strip.downcase
    until ['x', 'o'].include?(choice)
      puts 'Invalid character! Please try again:'
      choice = gets.chomp.strip.downcase
    end
    choice
  end
end
