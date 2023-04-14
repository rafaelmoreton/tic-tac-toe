require './tic_tac_toe.rb'

class ComputerTable < Table
    attr_reader :active_player

    def initialize
        @result = 'undefined'
        @cells = []; 9.times { |num| @cells << Cell.new(num + 1) } # + 1 accounts
        # for the difference between the array positions and the table display
        @players = []
        @players << ComputerPlayer.new('X')
        @players << ComputerPlayer.new('O')
        @active_player = nil
        Table.matches << self
    end
end

class ComputerPlayer < Player

    def initialize(token)
        @name = "Player #{token}"
        @player_token = token
        @target = nil
        Player.players << self
    end
end

class GameTree
    attr_accessor :table

    def initialize
        @table = ComputerTable.new
    end

    # Returns an array with all the currently valid plays
    def valid_cells
        @table.cells.select do |cell|
            cell.position.class == Integer
        end
    end

    def find_childrens
        

        valid_cells.each do |cell|
            return if 

            cell.position = @table.active_player.player_token
            valid_cells
        end
    end
end