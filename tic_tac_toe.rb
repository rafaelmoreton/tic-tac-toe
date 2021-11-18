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
    attr_reader :cells

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

    def display
        puts "\n_#{@cells[6].position}_|_#{@cells[7].position}_|_#{@cells[8].position}_\n_#{@cells[3].position}_|_#{@cells[4].position}_|_#{@cells[5].position}_\n #{@cells[0].position} | #{@cells[1].position} | #{@cells[2].position} "
    end
end

class Cell
    attr_reader :position

    def initialize(position)
        @position = position
    end

    def play(player_token)
        @position = player_token
    end
end

match = 1
matches = []

#Game loop
matches << Table.new(match)
matches[0].display