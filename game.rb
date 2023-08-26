# frozen_string_literal: true

require './player'
require './board'

class Game
  PLAYER_SYMBOLS = ['x', 'o']
  REPLAY = 'y'

  class GameState
    DRAW = :draw
    WIN = :win
    IN_PROGRESS = :in_progress
  end

  def initialize
    @board = Board.new
    @p1 = Player.new(ask_player_name(1), @board)
    @p2 = Player.new(ask_player_name(2), @board)

    initialize_players
  end

  def start_game
    enter_game_loop
  end

  private

  def initialize_players
    @p1.symbol = ask_for_symbol(@p1.name)
    @p2.symbol = @p1.symbol == PLAYER_SYMBOLS.first ? PLAYER_SYMBOLS.last : PLAYER_SYMBOLS.first
    announce("Second player (#{@p2.name}) was assigned #{@p2.symbol}!")
    @current_player = @p1.symbol == PLAYER_SYMBOLS.first
    @game_state = GameState::IN_PROGRESS
  end

  def ask_player_name(number)
    puts "Player #{number} name:"
    gets.chomp.strip
  end

  def ask_for_symbol(player_name)
    puts "#{player_name}'s symbol choice #{PLAYER_SYMBOLS.join(' or ')}:"
    choice = sanitized_input
    until PLAYER_SYMBOLS.include?(choice)
      puts 'Invalid character! Please try again:'
      choice = sanitized_input
    end
    choice
  end

  def enter_game_loop
    while @game_state == GameState::IN_PROGRESS
      play_round(active_player)
      detect_game_end
      switch_players
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

  def switch_players
    @current_player = !@current_player
  end

  def active_player
    @current_player ? @p1 : @p2
  end

  def ask_location
    regex = /[a-c][1-3]/
    loc = sanitized_input
    until loc.length == 2 && regex =~ loc && @board.empty_at?(loc)
      puts 'Inavlid input! Try again:'
      loc = sanitized_input
    end
    loc
  end

  def detect_game_end
    if active_player.in_stalemate?
      end_game(GameState::DRAW)
    elsif active_player.full_line?
      end_game(GameState::WIN, active_player)
    end
  end

  def end_game(state, winner = nil)
    @board.print_board
    puts 'Game has ended.'
    @game_state = state
    @winner = winner
  end

  def announce(message)
    puts message
  end

  def announce_winner
    puts "The winner is #{@winner.name}. Congratulations!"
  end

  def announce_draw
    puts 'No winner! This is a draw.'
  end

  def ask_try_again
    sleep 1
    announce("\nTry again? press \'#{REPLAY}\' to accept:")
    return unless sanitized_input == REPLAY

    @board.clear
    @p1.clear_stats
    @p2.clear_stats
    initialize_players
    enter_game_loop
  end

  def sanitized_input
    gets.chomp.gsub(/[[:space:]]/, '').downcase
  end
end
