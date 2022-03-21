module Validable
  VALID_MOVES = { 'r' => 'rock',
                  'p' => 'paper',
                  's' => 'scissors',
                  'l' => 'lizard',
                  'sp' => 'spock' }
  VALID_YES_NO = { 'y' => 'yes',
                   'n' => 'no' }

  def valid?(input, valid_hash)
    (valid_hash.keys + valid_hash.values).include?(input)
  end

  def valid_value(input, valid_hash)
    return valid_hash[input] if valid_hash.keys.include?(input)
    input
  end
end

class Player
  attr_accessor :name, :move, :points

  def initialize
    set_name
    @points = 0
  end

  def make_move(choice)
    return Rock.new if choice == 'rock'
    return Paper.new if choice == 'paper'
    return Scissors.new if choice == 'scissors'
    return Lizard.new if choice == 'lizard'
    return Spock.new if choice == 'spock'
  end
end

class Human < Player
  include Validable

  def set_name
    n = nil
    loop do
      puts "What's your name?"
      n = gets.chomp
      break unless n.empty?
      puts "Sorry, please enter a valid name."
    end
    self.name = n
  end

  def choose
    choice = nil
    loop do
      puts "Choose a move: [R]ock, [P]aper, [S]cissors, [L]izard, or [Sp]ock"
      choice = gets.chomp.downcase
      break if valid?(choice, Validable::VALID_MOVES)
      puts "Sorry, please enter a valid choice."
    end
    choice = valid_value(choice, Validable::VALID_MOVES)
    self.move = make_move(choice)
  end
end

class Computer < Player
  ROBOTS = ['R2D2', 'C3PO']

  def choose
    self.move = make_move(Move::VALUES.sample)
  end
end

class R2D2 < Computer
  def set_name
    self.name = 'R2D2'
  end

  def choose
    self.move = make_move('rock')
  end
end

class C3PO < Computer
  def set_name
    self.name = 'C3PO'
  end

  def choose
    scissors_or_random = [0, 1].sample
    if scissors_or_random == 0
      self.move = make_move('scissors')
    else
      super
    end
  end
end

class History
  def initialize
    @match_moves = []
  end

  def display_match(player_name, computer_name)
    @match_moves.each_with_index do |moves, index|
      puts "In the #{index + 1}#{game_index_suffix(index + 1)} game "\
           "#{player_name} chose #{moves.first} and #{computer_name} chose "\
           "#{moves.last}."
    end
  end

  def update_moves(player_move, computer_move)
    @match_moves << [player_move, computer_move]
  end

  private

  def game_index_suffix(index)
    return 'th' if [11, 12, 13].include?(index)
    last_digit = index % 10

    case last_digit
    when 1 then 'st'
    when 2 then 'nd'
    when 3 then 'rd'
    else 'th'
    end
  end
end

class Move
  VALUES = ['rock', 'paper', 'scissors', 'lizard', 'spock']

  attr_reader :value

  def to_s
    @value
  end
end

class Rock < Move
  def initialize
    @value = 'rock'
  end

  def >(other_move)
    other_move.class == Scissors || other_move.class == Lizard
  end
end

class Paper < Move
  def initialize
    @value = 'paper'
  end

  def >(other_move)
    other_move.class == Rock || other_move.class == Spock
  end
end

class Scissors < Move
  def initialize
    @value = 'scissors'
  end

  def >(other_move)
    other_move.class == Paper || other_move.class == Lizard
  end
end

class Lizard < Move
  def initialize
    @value = 'lizard'
  end

  def >(other_move)
    other_move.class == Spock || other_move.class == Paper
  end
end

class Spock < Move
  def initialize
    @value = 'spock'
  end

  def >(other_move)
    other_move.class == Rock || other_move.class == Scissors
  end
end

class RPSLSGame
  include Validable

  RULES_SLEEP_DURATION = 10
  SLEEP_DURATION = 2
  VICTORY_POINT_TOTAL = 3
  RULES = <<-RULES
  Here's what beats what in RPSLS:
  Scissors cuts Paper covers Rock crushes
  Lizard poisons Spock smashes Scissors
  decapitates Lizard eats Paper disproves
  Spock vaporizes Rock crushes Scissors.
  RULES

  attr_accessor :human, :computer, :history

  def initialize
    @human = Human.new
    @computer = set_computer_opponent
    @history = History.new
  end

  def play
    display_intro_message
    loop do
      match
      break unless play_again?
      reset
    end
    display_goodbye_message
  end

  private

  def set_computer_opponent
    opponent = Computer::ROBOTS.sample
    case opponent
    when 'R2D2'
      R2D2.new
    when 'C3PO'
      C3PO.new
    end
  end

  def display_intro_message
    clear
    puts "Welcome to Rock-Paper-Scissors-Lizard-Spock, #{human.name}!"
    sleep(SLEEP_DURATION)
    puts RULES
    sleep(RULES_SLEEP_DURATION)
    puts "Your opponent will be #{computer.name}."
    sleep(SLEEP_DURATION)
    puts "Each game won is worth 1 point. The first to #{VICTORY_POINT_TOTAL} "\
         "points wins the match!"
    sleep(SLEEP_DURATION)
  end

  def display_goodbye_message
    puts "Thank you for playing. Goodbye!"
  end

  def play_again?
    answer = nil
    loop do
      puts "Would you like to play again? Please enter [Y]es or [N]o."
      answer = gets.chomp.downcase
      break if valid?(answer, VALID_YES_NO)
      puts "Sorry, answer must be [Y]es or [N]o."
    end

    return true if valid_value(answer, VALID_YES_NO) == 'yes'
    false
  end

  def display_game_result
    clear
    puts "#{human.name} chose #{human.move} and #{computer.name} chose "\
         "#{computer.move}."
    sleep(SLEEP_DURATION)
    display_game_winner
    sleep(SLEEP_DURATION)
  end

  def display_game_winner
    if human.move > computer.move
      puts "#{human.name} wins!"
    elsif computer.move > human.move
      puts "#{computer.name} wins!"
    else
      puts "It's a tie!"
    end
  end

  def display_points
    puts "#{human.name} has #{human.points} points and #{computer.name} has "\
         "#{computer.points} points."
  end

  def human_won_game?
    human.move > computer.move
  end

  def computer_won_game?
    computer.move > human.move
  end

  def human_won_match?
    human.points == VICTORY_POINT_TOTAL
  end

  def computer_won_match?
    computer.points == VICTORY_POINT_TOTAL
  end

  def update_points
    if human_won_game?
      human.points += 1
    elsif computer_won_game?
      computer.points += 1
    end
  end

  def update_history
    history.update_moves(human.move, computer.move)
  end

  def display_match_winner
    if human_won_match?
      puts "#{human.name} is the first to #{VICTORY_POINT_TOTAL} points and "\
           "wins the match!"
    elsif computer_won_match?
      puts "#{computer.name} is the first to #{VICTORY_POINT_TOTAL} points "\
           "and wins the match!"
    end
  end

  def game
    human.choose
    computer.choose
    display_game_result
    update_points
    update_history
  end

  def match
    loop do
      break if human_won_match? || computer_won_match?
      game
    end
    sleep(SLEEP_DURATION)
    display_points
    sleep(SLEEP_DURATION)
    display_match_winner
    sleep(SLEEP_DURATION)
    history.display_match(human.name, computer.name)
  end

  def reset
    human.points = 0
    computer.points = 0
    self.history = History.new
  end

  def clear
    system 'clear'
  end
end

RPSLSGame.new.play
