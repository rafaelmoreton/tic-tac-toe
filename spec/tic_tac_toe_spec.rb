# frozen_string_literal: true

require_relative '../lib/tic_tac_toe'

# First we want to test the victory is triggered when a sequence is completed.
# This is accomplished by the Table class, so let's start there
describe Table do
  subject(:table) { described_class.new([player1, player2]) }
  let(:player1) { double(Player, name: 'Rafa') }
  let(:player2) { double(Player, name: 'Anna') }

  # To test that the game victory condition works we need to test the methods
  # responsible by this, namely: #some_winner?, whichs depends uppon #any_row?,
  # #any_line? and #any_diagonal?. Besides, we need to ensure that #some_winner?
  # is being called everytime there is a change in the state of the table
  # object, so the #play method will need to be tested too.

  describe '#some_winner?' do
    context 'when a row is complete' do
      before do
        allow(table).to receive(:any_row?).and_return(true)
      end
      it 'returns true' do
        result = table.some_winner?
        expect(result).to be true
      end
    end

    context 'when a column is complete' do
      before do
        allow(table).to receive(:any_column?).and_return(true)
      end
      it 'returns true' do
        result = table.some_winner?
        expect(result).to be true
      end
    end

    context 'when a diagonal is complete' do
      before do
        allow(table).to receive(:any_diagonal?).and_return(true)
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

    # At last, we need to ensure that #any_winner? is being called every time
    # the table state changes. This happens at #play condition check for
    # skiping it's loop to the next iteration. This will happen up to 9 times
    # if no line is completed and then #play continue, reaching the draw case
    # It will happen a minimum of 5 times because that's the number of turns it
    # takes for a player to complete the line in a two players alternating game.
    context 'when the game comes to a draw' do
      before do
        allow(player1).to receive(:choose_target!)
        allow(player2).to receive(:choose_target!)
        allow(table).to receive(:puts) # to avoid outputing the table display
      end
      it 'is called 9 times' do
        expect(table).to receive(:some_winner?).exactly(9).times
        table.play
      end
    end

    context 'when the game ends with player1 victory after 5 turns' do
      xit 'is called 5 times' do
        # How to stub #choose_target! for the player doubles? #choose_target
        # shoudn't have a return value, but instead change the player instance
        # @target attribute, which in turn will be used by to set the targeted
        # cell as taken by that player as in line 154 of tic_tac_toe.rb:
        # match.cells[target].position = player_token

        # Can't stub #choose_target! like in the previous example because this
        # way it's not possible to really mark a cell for a player on each rep
        # of the play loop and thus trigger the loop's exit codition for the
        # #choose_target! to only be called 5 times
      end
    end
  end

  # Now we need to ensure that the three any_<line>? methods work properly
  describe '#any_row?' do
    context 'when a row is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[1].position = 'x'
        table.cells[2].position = 'x'
      end
      it 'returns true' do
        result = table.any_row?
        expect(result).to be true
      end
    end

    context 'when no row is complete' do
      it 'does not return true' do
        result = table.any_row?
        expect(result).not_to be true
      end
    end
  end

  describe '#any_column?' do
    context 'when a column is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[3].position = 'x'
        table.cells[6].position = 'x'
      end
      it 'returns true' do
        result = table.any_column?
        expect(result).to be true
      end
    end

    context 'when no column is complete' do
      it 'does not return true' do
        result = table.any_column?
        expect(result).not_to be true
      end
    end
  end

  describe '#any_diagonal?' do
    context 'when a diagonal is complete' do
      before do
        table.cells[0].position = 'x'
        table.cells[4].position = 'x'
        table.cells[8].position = 'x'
      end
      it 'returns true' do
        result = table.any_diagonal?
        expect(result).to be true
      end
    end

    context 'when no diagonal is complete' do
      it 'does not return true' do
        result = table.any_diagonal?
        expect(result).not_to be true
      end
    end
  end
end
