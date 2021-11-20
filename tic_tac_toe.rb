# loop
#     quem será o jogador 1
#     quem será o jogador 2
#     [criar tabuleiro]
#     loop 2
#         pedir jogada 1
#         checar condição de vitória
#         alterar jogador
#     indicar vencedor ou empate
#     apagar tabuleiro
#     iniciar novo jogo?
#     mudar jogadores ou ordem de jogo?
# end

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
        puts "\n_#{@cells[6].position}_|_#{@cells[7].position}_|_#{@cells[8].position}_\n_#{@cells[3].position}_|_#{@cells[4].position}_|_#{@cells[5].position}_\n #{@cells[0].position} | #{@cells[1].position} | #{@cells[2].position} "
    end

    def play(target, active_player)
        target -= 1
        @cells[target].mark_for(active_player.player_token)
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
    attr_reader :player_token
    
    @@players_pool = []
    @@active_player = 0

    def initialize(name)
        @name = name
        @play_order = 0
        @player_token = 0
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

end

match = 0
matches = []

#Start game
matches << Table.new(match)
matches[0].display

name = gets.chomp
player1 = Player.new(name)
player1.choose_token("X")

matches[0].play(1, player1)
matches[0].play(2, player1)
matches[0].play(3, player1)
matches[0].display