require_relative "../lib/day21.rb"

describe "dice games" do
  let(:example_positions) { [4, 8] }
  let(:puzzle_positions) { [5, 6] }

  describe DeterministicGame do
    describe '#play_turn' do
      it "plays one turn" do
        game = DeterministicGame.new example_positions
        game.play_turn
        expect(game.current_player).to eq(1) # i.e. player 2
        expect(game.scores).to eq([10, 0])
      end
    end

    describe '#play' do
      it "plays until a player has a score >= 1000 (and replicates the example)" do
        game = DeterministicGame.new example_positions
        game.play
        expect(game.current_player).to eq(1)
        expect(game.scores).to eq([1000, 745])
        expect(game.roll_count).to eq(993)
      end

      it "solves the puzzle" do
        game = DeterministicGame.new puzzle_positions
        game.play
        expect(game.scores[game.current_player]).to eq(913)
        expect(game.roll_count).to eq(1098)
      end

    end

  end

  describe Multiverse do
    describe '#play_turn' do
      it "plays a turn" do
        mv = Multiverse.new example_positions
        mv.play_turn
        expected_players = [
          {
            Player.new(7, 7) => 1,
            Player.new(8, 8) => 3,
            Player.new(9, 9) => 6,
            Player.new(10, 10) => 7,
            Player.new(1, 1) => 6,
            Player.new(2, 2) => 3,
            Player.new(3, 3) => 1
          },
          { Player.new(8, 0) => 1 }
        ]
        expect(mv.players).to eq(expected_players)
        expect(mv.wins).to eq([0, 0])
      end

      it "plays 2 turns" do
        mv = Multiverse.new example_positions
        2.times { mv.play_turn }
        expected_players = [
          {
            Player.new(7, 7) => 1,
            Player.new(8, 8) => 3,
            Player.new(9, 9) => 6,
            Player.new(10, 10) => 7,
            Player.new(1, 1) => 6,
            Player.new(2, 2) => 3,
            Player.new(3, 3) => 1
          },
          {
            Player.new(1, 1) => 1,
            Player.new(2, 2) => 3,
            Player.new(3, 3) => 6,
            Player.new(4, 4) => 7,
            Player.new(5, 5) => 6,
            Player.new(6, 6) => 3,
            Player.new(7, 7) => 1
          }
        ]
        expect(mv.players).to eq(expected_players)
        expect(mv.wins).to eq([0, 0])
      end

      it "counts wins" do
        mv = Multiverse.new example_positions
        5.times { mv.play_turn }
        expect(mv.wins).to eq([3359232, 0])
      end

    end

    describe '#play' do
      it "plays until every game is won (and replicates the example)" do
        mv = Multiverse.new example_positions
        mv.play
        expect(mv.wins).to eq([444356092776315, 341960390180808])
      end

      it "solves the puzzle" do
        mv = Multiverse.new puzzle_positions
        mv.play
        expect(mv.wins).to eq([919758187195363, 635572886949720])
      end

    end

  end

end
