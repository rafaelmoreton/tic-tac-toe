# frozen_string_literal: true

# Used to create a instance for each match
class Table
  attr_reader :cells

  @@matches = []

  def initialize(match)
    @match = match
    @@matches << self
    @result = 'undefined'
    @cells = []
    9.times do |position|
      position += 1
      @cells << Cell.new(position)
    end
  end

  def display
    puts "
    _#{@cells[6].position}_|_#{@cells[7].position}_|_#{@cells[8].position}_
    _#{@cells[3].position}_|_#{@cells[4].position}_|_#{@cells[5].position}_
     #{@cells[0].position} | #{@cells[1].position} | #{@cells[2].position} "
  end

  def play(active_player, target)
    target -= 1
    @cells[target].mark_for(active_player.player_token)
  end

  def some_winner?
    # Rows
    if cells[0].position == cells[1].position && cells[0].position == cells[2].position
      true
    elsif cells[3].position == cells[4].position && cells[3].position == cells[5].position
      true
    elsif cells[6].position == cells[7].position && cells[6].position == cells[8].position
      true

    # Columns
    elsif cells[0].position == cells[3].position && cells[0].position == cells[6].position
      true
    elsif cells[1].position == cells[4].position && cells[1].position == cells[7].position
      true
    elsif cells[2].position == cells[5].position && cells[2].position == cells[8].position
      true

    # Diagonals
    elsif cells[0].position == cells[4].position && cells[0].position == cells[8].position
      true
    elsif cells[2].position == cells[4].position && cells[2].position == cells[6].position
      true
    else
      false
    end
  end
end

# Each instance of Table creates 9 instances of Cell to populate it.
class Cell
  attr_reader :position

  def initialize(position)
    @position = position
  end

  def mark_for(player)
    @position = player
  end
end

# Each instance of player is used to keep track of the player's name, token, and to alternate turns between them
class Player
  attr_reader :player_token, :name, :target

  @@players_pool = []
  @active_player = 0

  def initialize(name)
    @name = name
    @player_token = 0
    @play_order = 0
    @target = 0
    @@players_pool << self
  end

  def self.players_pool
      @@players_pool
  end

  def self.active_player(player)
      @@active_player = player
  end

  def get_token
      valid_token = false
      while valid_token == false
          input = gets.chomp
          if input.length > 1
              puts "#{input} isn't a valid token. Select a one digit token."
          elsif input.ord <= 32 || (input.ord >= 48 && input.ord <= 57) 
              puts "#{input} is a number. Therefore it cannot be used as a token."
          else
              @player_token = input
              valid_token = true
          end
      end
  end

  def get_target(match)
      valid_target = false
      while valid_target == false
          original_input = gets.chomp
          player_input = original_input.to_i
          if match.cells.any? { |cell| cell.position == player_input}
              @target = player_input
              valid_target = true
          else
              puts "#{original_input} isn't a valid target. Pick a number from the board."
          end
      end
  end

  def win
      puts "\n\nGame over. #{name} is the winner!"
  end

end

#Global tracking variables
match = 0
matches = []

#New Players
puts "\n\nWhat's the first player's name?"
name1 = gets.chomp
player1 = Player.new(name1)
puts "\n\nWhat's going to be #{name1}'s token?"
player1.get_token

puts "\n\nWhat's the second player's name?"
name2 = gets.chomp
player2 = Player.new(name2)
puts "\n\nWhat's going to be #{name2}'s token?"
player2.get_token

while true do
  #Start game
  matches << Table.new(match)
  sleep(2)
  puts "\n\nStarting match #{(match+1)}..."
  sleep(1)

  #Players turns (4 rounds and 1 turn)
  4.times do
      puts "\n\nIt's #{player1.name}'s turn."
      matches[match].display
      player1.get_target(matches[match])
      matches[match].play(player1, player1.target)
      if matches[match].some_winner?
          player1.win
          matches[match].display
          break
      end

      puts "\n\nIt's #{player2.name}'s turn."
      matches[match].display
      player2.get_target(matches[match])
      matches[match].play(player2, player2.target)
      if matches[match].some_winner?
          player2.win
          matches[match].display
          break
      end
  end
  if !matches[match].some_winner?
      puts "\n\nIt's #{player1.name}'s turn."
      matches[match].display
      player1.get_target(matches[match])
      matches[match].play(player1, player1.target)
      if matches[match].some_winner?
          player1.win
          matches[match].display
      else
          puts "\n\nGame over. It's draw."
      end
  end

  match += 1
end