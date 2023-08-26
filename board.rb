# frozen_string_literal: true

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
