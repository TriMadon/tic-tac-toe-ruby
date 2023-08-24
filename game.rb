class Game
  def initialize
    p1_name = ask_p1_name
    p2_name = ask_p2_name

    p1_symbol = ask_p1_symbol(p1_name)
    p2_symbol = p1_symbol == 'o' ? 'x' : 'o'
    puts "Second player (#{p2_name}) was assigned #{p2_symbol}!"

    @p1 = Player.new(p1_name, p1_symbol)
    @p2 = Player.new(p2_name, p2_symbol)
  end

  def ask_p1_name
    puts 'First player\'s name:'
    gets.chomp
  end

  def ask_p2_name
    puts 'Second player\'s name:'
    gets.chomp
  end

  def ask_p1_symbol(name)
    puts "First player (#{name})'s symbol choice (x or o):"
    input = gets.chomp.downcase
    until ['x', 'o'].include?(input)
      puts 'Invalid character! Please try again:'
      input = gets.chomp.downcase
    end
  end
end
