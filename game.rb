# frozen_string_literal: true

require './player'
require './board'

class Game
  PLAYER_SYMBOLS = ['x', 'o'].freeze
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

    initialize_players
  end

  def start_game
    enter_game_loop
  end

  private

  def initialize_players
    @p1.symbol = ask_for_symbol(@p1.name)
    @p2.symbol = @p1.symbol == PLAYER_SYMBOLS.first ? PLAYER_SYMBOLS.last : PLAYER_SYMBOLS.first
    puts "Second player (#{@p2.name}) was assigned #{@p2.symbol}!"
    @active_player = @p1.symbol == PLAYER_SYMBOLS.first ? @p1 : @p2
    @game_state = GameState::IN_PROGRESS
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
    puts ''
    @board.print_board
    puts ''

    if @board.empty?
      puts "#{player.name} (x) begins first:"
    else
      puts "#{player.name}'s (#{player.symbol}) turn:"
    end

    location = ask_location
    player.draw_symbol(location)
  end

  def ask_p1_name
    puts 'First player\'s name:'
    gets.chomp.strip
  end

  def ask_p2_name
    puts 'Second player\'s name:'
    gets.chomp.strip
  end

  def ask_for_symbol(player_name)
    puts "#{player_name}'s symbol choice #{PLAYER_SYMBOLS.join(' or ')}:"
    choice = gets.chomp.strip.downcase
    until PLAYER_SYMBOLS.include?(choice)
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
    if stalemate?(@p1) || stalemate?(@p2)
      end_game(GameState::DRAW)
    elsif player_has_full_line?(@p1) || player_has_full_line?(@p2)
      end_game(GameState::WIN, @p1.full_line? ? @p1 : @p2)
    end
  end

  def player_has_full_line?(player)
    player.full_line?
  end

  def stalemate?(player)
    player.in_stalemate?
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
    sleep 1
    puts ''
    puts 'Try again? press \'y\' to accept:'
    return unless gets.chomp.gsub(/[[:space:]]/, '').downcase == 'y'

    board.clear
    @p1.clear_stats
    @p2.clear_stats
    initialize_players
    enter_game_loop
  end
end
