# frozen_string_literal: true

require './player'
require './board'

class Game
  attr_accessor :p1, :p2, :active_player, :game_is_done, :board

  def initialize
    p1_name = ask_p1_name
    p2_name = ask_p2_name
    p1_symbol = ask_p1_symbol(p1_name)
    p2_symbol = p1_symbol == 'o' ? 'x' : 'o'
    puts "Second player (#{p2_name}) was assigned #{p2_symbol}!"

    @p1 = Player.new(p1_name, p1_symbol)
    @p2 = Player.new(p2_name, p2_symbol)

    @board = Board.new
    @active_player = @p1.symbol == 'x' ? @p1 : @p2
    @game_is_done = false

    enter_game_loop
  end

  def enter_game_loop
    until game_is_done
      play_round(@active_player)
      switch_players
    end
  end

  def play_round(player)
    @board.print_board

    if @board.empty?
      puts "#{player.name} (x) begins first:"
    else
      puts "#{player.name}'s (#{player.symbol}) turn:"
    end

    location = ask_location
    @board.draw(location, player.symbol)
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

  def switch_players
    @active_player = @active_player == @p1 ? @p2 : @p1
  end

  def ask_location
    regex = /[a-c][1-3]/
    loc = gets.chomp.gsub(/[[:space:]]/, '').downcase
    until loc.length == 2 && regex =~ loc && @board.empty_at?(loc)
      puts 'Inavlid input! Try again:'
      loc = gets.chomp.gsub(/[[:space:]]/, '').downcase
    end
    loc
  end
end
