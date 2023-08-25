# frozen_string_literal: true

class Player
  attr_accessor :symbol

  def initialize(name, symbol)
    @name = name
    @symbol = symbol
  end
end
