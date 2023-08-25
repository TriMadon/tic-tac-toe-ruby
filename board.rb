# frozen_string_literal: true

class Board
  attr_accessor :tile_states

  LETTER_TO_NUM = { 'a' => 0, 'b' => 1, 'c' => 2 }.freeze

  def initialize
    @tile_states = Array.new(3) { Array.new(3, ' ') }
  end

  def print_board
    lines = ['    1   2   3', '   ——— ——— ———']
    %w[A B C].each.with_index do |letter, index|
      lines << "#{letter} #{print_row(tile_states[index])}"
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

  private

  def print_row(row)
    "|#{row.reduce('') { |res, sym| res + " #{sym} |" }}"
  end
end
