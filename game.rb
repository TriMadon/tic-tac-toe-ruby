# frozen_string_literal: true

require './player'
require './board'

class Game
  class GameState
    DRAW = :draw
    WIN = :win
    IN_PROGRESS = :in_progress
  end

  attr_accessor :p1, :p2, :active_player, :game_state, :board, :winner

  def initialize
    @board = Board.new

    p1_name = ask_p1_name
    p2_name = ask_p2_name

    @p1 = Player.new(p1_name, board)
    @p2 = Player.new(p2_name, board)

    @p1.symbol = ask_p1_symbol
    @p2.symbol = @p1.symbol == 'o' ? 'x' : 'o'
    puts "Second player (#{@p2.name}) was assigned #{@p2.symbol}!"

    @active_player = @p1.symbol == 'x' ? @p1 : @p2
    @game_state = GameState::IN_PROGRESS
    @winner = nil

    enter_game_loop
  end

  def enter_game_loop
    while @game_state == GameState::IN_PROGRESS
      play_round(@active_player)
      switch_players
      detect_game_end
    end

    announce_winner if @game_state == GameState::WIN
    announce_draw if @game_state == GameState::DRAW

    ask_try_again
  end

  def play_round(player)
    @board.print_board

    if @board.empty?
      puts "#{player.name} (x) begins first:"
    else
      puts "#{player.name}'s (#{player.symbol}) turn:"
    end

    location = ask_location
    player.draw_symbol(location)
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

  def ask_p1_symbol
    puts "First player (#{@p1.name})'s symbol choice (x or o):"
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

  def detect_game_end
    if @p1.in_stalemate? || @p2.in_stalemate?
      end_game(GameState::DRAW)
    elsif @p1.full_line?
      end_game(GameState::WIN, @p1)
    elsif @p2.full_line?
      end_game(GameState::WIN, @p2)
    end
  end

  def end_game(state, winner = nil)
    @board.print_board
    puts 'Game has ended.'
    @game_state = state
    @winner = winner
  end

  def announce_winner
    puts "The winner is #{@winner.name}. Congratulations!"
  end

  def announce_draw
    puts 'No winner! This is a draw.'
  end

  def ask_try_again
    puts 'Try again? press \'y\' to continue'
    return unless gets.chomp.gsub(/[[:space:]]/, '').downcase == 'y'

    @p1.symbol = ask_p1_symbol
    @p2.symbol = @p1.symbol == 'o' ? 'x' : 'o'
    @p1.clear_stats
    @p2.clear_stats
    board.clear
    @game_state = GameState::IN_PROGRESS
    @winner = nil
    @active_player = @p1.symbol == 'x' ? @p1 : @p2
    enter_game_loop
  end
end
