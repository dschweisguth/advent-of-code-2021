require_relative "../lib/day13.rb"

describe Paper do
  describe '#fold' do
    context "folding along the x axis" do
      it "folds the smallest foldable paper" do
        instructions = '
          2,0
          fold along x=1
        '
        expect_fold_to_produce instructions, [%w[#]]
      end

      it "folds left of center" do
        instructions = '
          0,0
          3,0
          fold along x=1
        '
        expect_fold_to_produce instructions, [%w[# #]]
      end

      it "folds right of center" do
        instructions = '
          0,0
          3,0
          fold along x=2
        '
        expect_fold_to_produce instructions, [%w[# #]]
      end

    end

    context "folding along the y axis" do
      it "folds the smallest foldable paper" do
        instructions = '
          0,2
          fold along y=1
        '
        expect_fold_to_produce instructions, [['#']]
      end

      it "folds above center" do
        instructions = '
          0,0
          0,3
          fold along y=1
        '
        expect_fold_to_produce instructions, [['#'], ['#']]
      end

      it "folds below center" do
        instructions = '
          0,0
          0,3
          fold along y=2
        '
        expect_fold_to_produce instructions, [['#'], ['#']]
      end

    end

    it "handles multiple folds" do
      instructions = '
        0,0
        1,0
        3,1
        0,3
        fold along x=2
        fold along y=2
      '
      expect_fold_to_produce instructions, [
        %w[# #],
        %w[# #]
      ]

    end

    def expect_fold_to_produce(instructions, expected_coordinates)
      paper = Paper.new instructions.strip.split("\n")
      paper.fold
      expect(paper.coordinates).to eq(expected_coordinates)
    end

    it "replicates the example" do
      instructions = '
        6,10
        0,14
        9,10
        0,3
        10,4
        4,11
        6,0
        6,12
        4,1
        0,13
        10,12
        3,4
        3,0
        8,4
        1,10
        2,14
        8,10
        9,0

        fold along y=7
        fold along x=5
      '.strip.split "\n"
      print_result instructions
    end

    it "solves the first step of the puzzle" do
      instructions = IO.readlines('spec/day13_input.txt').map { |line| line.chomp }
      first_step_instructions = instructions.grep /,/
      first_step_instructions << instructions.find { |instruction| instruction =~ /fold/ }
      paper = Paper.new first_step_instructions
      paper.fold
      expect(paper.mark_count).to eq(735)
    end

    it "solves the whole puzzle" do
      instructions = IO.readlines('spec/day13_input.txt').map { |line| line.chomp }
      print_result instructions
    end

    def print_result(instructions)
      paper = Paper.new instructions
      paper.fold
      # paper.coordinates.each { |row| puts row.join }
    end

  end

  describe '#mark_count' do
    it "counts marks" do
      instructions = '
        0,0
        1,1
        2,2
      '.strip.split "\n"
      expect(Paper.new(instructions).mark_count).to eq(3)
    end
  end

end
