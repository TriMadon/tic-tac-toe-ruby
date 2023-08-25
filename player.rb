# frozen_string_literal: true

class Player
  attr_accessor :symbol
  attr_reader :name

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
