require_relative "../lib/day04.rb"

module Day04
  describe Match do
    let(:simple_numberses) do
      [
        [
          [ 0,  1,  2,  3,  4],
          [ 5,  6,  7,  8,  9],
          [10, 11, 12, 13, 14],
          [15, 16, 17, 18, 19],
          [20, 21, 22, 23, 24]
        ],
        [
          [25, 26, 27, 28, 29],
          [30, 31, 32, 33, 34],
          [35, 36, 37, 38, 39],
          [40, 41, 42, 43, 44],
          [45, 46, 47, 48, 49]
        ]
      ]
    end

    let(:example_numberses) do
      numberses %q(
          22 13 17 11  0
           8  2 23  4 24
          21  9 14 16  7
           6 10  3 18  5
           1 12 20 15 19

           3 15  0  2 22
           9 18 13 17  5
          19  8  7 25 23
          20 11 10 24  4
          14 21 16 12  6

          14 21 17 24  4
          10 16 15  9 19
          18  8 23 26 20
          22 11 13  6  5
           2  0 12  3  7
        ).
        split("\n")
    end

    let(:example_draws) { [7, 4, 9, 5, 11, 17, 23, 2, 0, 14, 21, 24, 10, 16, 13, 6, 15, 25, 12, 22, 18, 20, 8, 19, 3, 26, 1] }

    let(:puzzle_numberses) { numberses IO.readlines 'spec/day04_input.txt' }

    let(:puzzle_draws) { [37, 60, 87, 13, 34, 72, 45, 49, 61, 27, 97, 88, 50, 30, 76, 40, 63, 9, 38, 67, 82, 6, 59, 90, 99, 54, 11, 66, 98, 23, 64, 14, 18, 4, 10, 89, 46, 32, 19, 5, 1, 53, 25, 96, 2, 12, 86, 58, 41, 68, 95, 8, 7, 3, 85, 70, 35, 55, 77, 44, 36, 51, 15, 52, 56, 57, 91, 16, 71, 92, 84, 17, 33, 29, 47, 75, 80, 39, 83, 74, 73, 65, 78, 69, 21, 42, 31, 93, 22, 62, 24, 48, 81, 0, 26, 43, 20, 28, 94, 79] }

    def numberses(lines)
      lines.
        reject { |line| line =~ /^\s*$/ }.
        map { |line| line.split.map { |string| Integer(string) } }.
        each_slice(5).
        to_a
    end

    describe '#play' do
      it "plays until the first board has won" do
        match = Match.new simple_numberses, [0, 1, 2, 3, 4]
        match.play_to_first_win
        expect(match.winners.map &:numbers).to eq([simple_numberses[0]])
      end

      it "replicates the example" do
        match = Match.new example_numberses, example_draws
        match.play_to_first_win
        winners = match.winners
        expect(winners.length).to eq(1)
        winner = winners[0]
        expect(winner.numbers).to eq(example_numberses[2])
        expect(winner.score).to eq(4512)
      end

      it "solves the puzzle" do
        match = Match.new puzzle_numberses, puzzle_draws
        match.play_to_first_win
        winners = match.winners
        expect(winners.length).to eq(1)
        expect(winners[0].score).to eq(34506)
      end

    end

    describe '#play_all' do
      it "plays until the last board has won" do
        numberses = [
          [
            [ 0,  1,  2,  3,  4],
            [ 5,  6,  7,  8,  9],
            [10, 11, 12, 13, 14],
            [15, 16, 17, 18, 19],
            [20, 21, 22, 23, 24]
          ],
          [
            [25, 26, 27, 28, 29],
            [30, 31, 32, 33, 34],
            [35, 36, 37, 38, 39],
            [40, 41, 42, 43, 44],
            [45, 46, 47, 48, 49]
          ]
        ]
        match = Match.new numberses, [0, 1, 2, 3, 4, 25, 26, 27, 28, 29]
        match.play_to_last_win
        expect(match.winners.map &:numbers).to eq(numberses)
      end

      it "replicates the example" do
        match = Match.new example_numberses, example_draws
        match.play_to_last_win
        winners = match.winners
        expect(winners.length).to eq(3)
        last_winner = winners.last
        expect(last_winner.numbers).to eq(example_numberses[1])
        expect(last_winner.score).to eq(1924)
      end

      it "solves the puzzle" do
        match = Match.new puzzle_numberses, puzzle_draws
        match.play_to_last_win
        expect(match.winners.last.score).to eq(7686)
      end

    end

  end

  describe Board do
    describe '#winner?' do
      it "recognizes a win in a column" do
        board = Board.new [
          [ 0,  1,  2,  3,  4],
          [ 5,  6,  7,  8,  9],
          [10, 11, 12, 13, 14],
          [15, 16, 17, 18, 19],
          [20, 21, 22, 23, 24]
        ]
        [0, 5, 10, 15, 20].each { |number| board.mark number }
        expect(board.winner?).to be_truthy
      end
    end

    describe '#score' do
      it "returns the sum of unmarked numbers times the last marked number" do
        board = Board.new [
          [ 0,  1,  2,  3,  4],
          [ 5,  6,  7,  8,  9],
          [10, 11, 12, 13, 14],
          [15, 16, 17, 18, 19],
          [20, 21, 22, 23, 24]
        ]
        board.mark 11
        expect(board.score).to eq(((0..24).to_a.sum - 11) * 11)
      end
    end

  end

end
