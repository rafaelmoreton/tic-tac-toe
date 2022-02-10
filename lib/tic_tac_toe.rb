# frozen_string_literal: true

# Table instances are used to initialize each match with it's attributes (two
# of them being arrays of the Cell and Player instances of the current match)
# and provide the methods to run the current match.
# Table class' @matches attribute provides a way to storage and access the
# current and past matches data.
class Table
  attr_reader :cells

  class << self
    attr_accessor :matches
  end
  @matches = []

  def initialize(players)
    @result = 'undefined'
    @cells = []; 9.times { |num| @cells << Cell.new(num + 1) } # + 1 accounts
    # for the difference between the array positions and the table display
    @players = players
    @active_player = nil
    Table.matches << self
  end

  def play
    9.times do
      next_player
      display
      @active_player.choose_target!(self)
      next unless some_winner?

      @active_player.win
      display
      return
    end
    puts "It's a draw!"
  end

  def next_player
    @active_player =
      if @active_player == @players[0]
        @players[1]
      else
        @players[0]
      end
    puts "\n\nIt's #{@active_player.name}'s turn."
  end

  def display
    puts <<~GRID
      #{cells[6..8].map { |cell| "_#{cell.position}_" }.join('|')}
      #{cells[3..5].map { |cell| "_#{cell.position}_" }.join('|')}
      #{cells[0..2].map { |cell| " #{cell.position} " }.join('|')}
    GRID
  end

  def some_winner?
    [any_row?, any_column?, any_diagonal?].any?(true)
  end

  def any_row?
    return true if
    [
      cells[0..2],
      cells[3..5],
      cells[6..8]
    ].any? do |row|
      row.map(&:position).uniq.length == 1
    end
  end

  def any_column?
    return true if
    [
      [cells[0], cells[3], cells[6]],
      [cells[1], cells[4], cells[7]],
      [cells[2], cells[5], cells[8]]
    ].any? do |column|
      column.map(&:position).uniq.length == 1
    end
  end

  def any_diagonal?
    return true if
    [
      [cells[0], cells[4], cells[8]],
      [cells[2], cells[4], cells[6]]
    ].any? do |column|
      column.map(&:position).uniq.length == 1
    end
  end
end

# Each instance of Table creates 9 instances of Cell to populate it.
class Cell
  attr_accessor :position

  def initialize(position)
    @position = position
  end
end

# Each instance of player is used to keep track of the player's name, token, and to alternate turns between them
class Player
  attr_reader :player_token, :name, :target

  class << self
    attr_accessor :players, :active_player
  end
  @players = []
  @active_player = 0

  def initialize
    @name = set_name!
    @player_token = set_token!
    @target = nil
    Player.players << self
  end

  def set_name!
    if Player.players.empty?
      puts "\n\nWhat's the first player's name?"
    else
      puts "\n\nWhat's the second player's name?"
    end
    gets.chomp
  end

  def set_token!
    puts "\n\nWhat's going to be #{name}'s token?"
    loop do
      input = gets.chomp
      if input.length > 1
        puts "'#{input}' isn't a valid token. Select a one digit token."
      elsif input.ord <= 32 || (input.ord >= 48 && input.ord <= 57)
        puts "'#{input}' is a number. Therefore it cannot be used as a token."
      elsif Player.players[0] && Player.players[0].player_token == input
        puts "#{Player.players[0].name} has already selected the token "\
        "'#{input}'"
      else
        return input
      end
    end
  end

  def choose_target!(match)
    loop do
      original_input = gets.chomp
      player_input = original_input.to_i
      if match.cells.any? { |cell| cell.position == player_input }
        @target = player_input - 1
        # ' -1 ' accounts for the difference from the console display to the
        # cells' position attribute
        match.cells[target].position = player_token
        break
      else
        puts "#{original_input} isn't a valid target. Pick a number from the"\
          ' board.'
      end
    end
  end

  def win
    puts "\n\nGame over. #{name} is the winner!"
  end
end