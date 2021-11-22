class Table

    def initialize(match)
        @match = match
        @result = "undefined"
        @cells = []
        match += 1
        9.times do |position|
            position += 1
            @cells << Cell.new(position)
        end
    end

    def cells
        @cells
    end

    def display
        puts "\n_#{@cells[6].position}_|_#{@cells[7].position}_|_#{@cells[8].position}_\n_#{@cells[3].position}_|_#{@cells[4].position}_|_#{@cells[5].position}_\n #{@cells[0].position} | #{@cells[1].position} | #{@cells[2].position} \n"
    end

    def play(active_player, target)
        target -= 1
        @cells[target].mark_for(active_player.player_token)
    end

    def is_there_a_winner?
        #Rows
        if cells[0].position == cells[1].position && cells[0].position == cells[2].position
            return true
        elsif cells[3].position == cells[4].position && cells[3].position == cells[5].position
            return true
        elsif cells[6].position == cells[7].position && cells[6].position == cells[8].position
            return true
        
        #Columns
        elsif cells[0].position == cells[3].position && cells[0].position == cells[6].position
            return true
        elsif cells[1].position == cells[4].position && cells[1].position == cells[7].position
            return true
        elsif cells[2].position == cells[5].position && cells[2].position == cells[8].position
            return true

        #Diagonals
        elsif cells[0].position == cells[4].position && cells[0].position == cells[8].position
            return true
        elsif cells[2].position == cells[4].position && cells[2].position == cells[6].position
            return true

        else return false
        end
    end

end

class Cell
    attr_reader :position

    def initialize(position)
        @position = position
    end

    def mark_for(player)
        @position = player        
    end

end

class Player
    attr_reader :player_token, :name, :target
    
    @@players_pool = []
    @@active_player = 0

    def initialize(name, player_token)
        @name = name
        @player_token = player_token
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

    def choose_token(token)
        @player_token = token
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
puts "\n\nWhat's going to be #{name1}'s token?"
token1 = gets.chomp
player1 = Player.new(name1, token1)

puts "\n\nWhat's the second player's name?"
name2 = gets.chomp
puts "\n\nWhat's going to be #{name2}'s token?"
token2 = gets.chomp
player2 = Player.new(name2, token2)

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
        if matches[match].is_there_a_winner?
            player1.win
            matches[match].display
            break
        end

        puts "\n\nIt's #{player2.name}'s turn."
        matches[match].display
        player2.get_target(matches[match])
        matches[match].play(player2, player2.target)
        if matches[match].is_there_a_winner?
            player2.win
            matches[match].display
            break
        end
    end
    if !matches[match].is_there_a_winner?
        puts "\n\nIt's #{player1.name}'s turn."
        matches[match].display
        player1.get_target(matches[match])
        matches[match].play(player1, player1.target)
        if matches[match].is_there_a_winner?
            player1.win
            matches[match].display
        else
            puts "\n\nGame over. It's draw."
        end
    end

    match += 1
end