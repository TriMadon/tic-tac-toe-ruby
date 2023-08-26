# frozen_string_literal: true

module TicTacToe
  PLAYER_SYMBOLS = ['x', 'o']
  REPLAY = 'y'

  class GameState
    DRAW = :draw
    WIN = :win
    IN_PROGRESS = :in_progress
  end

  class Game
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

  class Board
    LETTER_TO_NUM = { 'a' => 0, 'b' => 1, 'c' => 2 }.freeze

    def initialize
      @tile_states = Array.new(3) { Array.new(3, ' ') }
    end

    def print_board
      lines = ['    1   2   3', '   ——— ——— ———']
      %w[A B C].each.with_index do |letter, index|
        lines << "#{letter} #{print_row(@tile_states[index])}"
        lines << '   ——— ——— ———'
      end
      puts lines.join("\n")
    end

    def empty?
      @tile_states.flatten.all?(' ')
    end

    def empty_at?(location)
      row = LETTER_TO_NUM[location[0]]
      col = location[1].to_i - 1

      @tile_states[row][col] == ' '
    end

    def draw(location, symbol)
      row = LETTER_TO_NUM[location[0]]
      col = location[1].to_i - 1

      @tile_states[row][col] = symbol.upcase
    end

    def full_symbol_line?(sym)
      sym = sym.upcase

      3.times do |i|
        return true if filled_with_symbol?(row(i), sym)
        return true if filled_with_symbol?(column(i), sym)
      end
      return true if filled_with_symbol?(main_diagonal, sym)
      return true if filled_with_symbol?(counter_diagonal, sym)

      false
    end

    def clear
      @tile_states = Array.new(3) { Array.new(3, ' ') }
    end

    private

    def print_row(row)
      "|#{row.reduce('') { |res, sym| res + " #{sym} |" }}"
    end

    def filled_with_symbol?(arr, sym)
      arr.all?(sym)
    end

    def row(index)
      @tile_states[index]
    end

    def column(index)
      @tile_states.map { |row| row[index] }
    end

    def main_diagonal
      @tile_states.each_with_index.map { |row, index| row[index] }
    end

    def counter_diagonal
      @tile_states.each_with_index.map { |row, index| row[2 - index] }
    end
  end
end
