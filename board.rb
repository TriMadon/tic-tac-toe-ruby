# frozen_string_literal: true

class Board
  attr_accessor :tile_states

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

  private

  def print_row(row)
    "|#{row.reduce('') { |res, sym| res + " #{sym} |" }}"
  end
end
