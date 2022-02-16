# frozen_string_literal: true

require_relative '../lib/tic_tac_toe'

# First we want to test the victory is triggered when a sequence is completed.
# This is accomplished by the Table class, so let's start there
describe Table do
  subject(:table) { described_class.new([player1, player2]) }
  let(:player1) { double(Player, name: 'Rafa', player_token: 'r') }
  let(:player2) { double(Player, name: 'Anna', player_token: 'a') }

  # To test that the game victory condition works we need to test the methods
  # responsible by this, namely: #some_winner?, whichs depends uppon #any_row?,
  # #any_line? and #any_diagonal?. Besides, we need to ensure that #some_winner?
  # is being called everytime there is a change in the state of the table
  # object, so the #play method will need to be tested too.

  describe '#some_winner?' do
    context 'when a row is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[1].position = 'x'
        table.cells[2].position = 'x'
      end
      it 'returns true' do
        result = table.some_winner?
        expect(result).to be true
      end
    end

    context 'when a column is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[3].position = 'x'
        table.cells[6].position = 'x'
      end
      it 'returns true' do
        result = table.some_winner?
        expect(result).to be true
      end
    end

    context 'when a diagonal is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[4].position = 'x'
        table.cells[8].position = 'x'
      end
      it 'returns true' do
        result = table.some_winner?
        expect(result).to be true
      end
    end

    context 'when no line is complete (eg: at game start)' do
      it 'does not return true' do
        result = table.some_winner?
        expect(result).not_to be true
      end
    end
  end

    # At last, we need to ensure that #some_winner? is being called every time
    # the table state changes. This happens at #play condition check for
    # skiping it's loop to the next iteration. This will happen up to 9 times
    # if no line is completed and then #play continue, reaching the draw case
    # It will happen a minimum of 5 times because that's the number of turns it
    # takes for a player to complete the line in a two players alternating game.
  describe '#play' do
    context 'when the game comes to a draw' do
      before do
        allow(player1).to receive(:choose_target).and_return(4, 7, 0, 5, 2)
        allow(player2).to receive(:choose_target).and_return(6, 1, 8, 3)
        allow(table).to receive(:puts) # to avoid outputing the table display
      end
      it 'check for victory is made 9 times' do
        expect(table).to receive(:some_winner?).exactly(9).times
        table.play
      end

      it 'outputs the draw message' do
        expect(table).to receive(:puts).with("\nIt's a draw!")
        table.play
      end
    end

    context 'when player 1 wins on 5th round' do
      before do
        allow(player1).to receive(:choose_target).and_return(0, 1, 2)
        allow(player2).to receive(:choose_target).and_return(5, 8)
        allow(table).to receive(:puts)
      end

      it 'there is a winner' do
        table.play
        result = table.some_winner?
        expect(result).to be true
      end

      it 'outputs the win message' do
        active_player = player1
        expect(table).to receive(:puts).with("\n#{active_player.name} is the winner!")
        table.play
      end

      it 'only iterates through the game loop 5 times' do
        expect(table).to receive(:display).exactly(6).times # 5 times from #next_player, 1 time from #win
        table.play
      end
    end
  end
end
