require_relative "../lib/day05.rb"

describe Day05 do
  let(:example_lines) do
    <<~END.split "\n"
      0,9 -> 5,9
      8,0 -> 0,8
      9,4 -> 3,4
      2,2 -> 2,1
      7,0 -> 7,4
      6,4 -> 2,0
      0,9 -> 2,9
      3,4 -> 1,4
      0,0 -> 8,8
      5,5 -> 8,2
    END
  end

  let(:puzzle_lines) { IO.readlines 'spec/day05_input.txt' }

  describe '#intersection_count_without_diagonals' do
    it "counts the intersections of two lines" do
      lines = ['0,0 -> 1,0', '1,0 -> 2,0']
      expect(subject.intersection_count_without_diagonals lines).to eq(1)
    end

    it "replicates the example" do
      expect(subject.intersection_count_without_diagonals example_lines).to eq(5)
    end

    xit "solves the puzzle" do
      expect(subject.intersection_count_without_diagonals puzzle_lines).to eq(6572)
    end

  end

  describe '#intersection_count_with_diagonals' do
    it "counts the intersections of two lines" do
      lines = ['0,0 -> 1,1', '1,1 -> 2,2']
      expect(subject.intersection_count_with_diagonals lines).to eq(1)
    end

    it "replicates the example" do
      expect(subject.intersection_count_with_diagonals example_lines).to eq(12)
    end

    xit "solves the puzzle" do
      expect(subject.intersection_count_with_diagonals puzzle_lines).to eq(21466)
    end

  end

end

describe Line do
  describe '#points' do
    it "returns the points in a horizontal line, start x < finish x" do
      expect(Line.new(0, 0, 1, 0).points).to eq([Point.new(0, 0), Point.new(1, 0)])
    end

    it "returns the points in a horizontal line, finish x < start x" do
      expect(Line.new(1, 0, 0, 0).points).to eq([Point.new(1, 0), Point.new(0, 0)])
    end

    it "returns the points in a vertical line, start y < finish y" do
      expect(Line.new(0, 0, 0, 1).points).to eq([Point.new(0, 0), Point.new(0, 1)])
    end

    it "returns the points in a vertical line, finish y < start y" do
      expect(Line.new(0, 1, 0, 0).points).to eq([Point.new(0, 1), Point.new(0, 0)])
    end

    it "returns the points in a diagonal line, start x < finish x & start y < finish y" do
      expect(Line.new(0, 0, 1, 1).points).to eq([Point.new(0, 0), Point.new(1, 1)])
    end

    it "returns the points in a diagonal line, start x < finish x & start y > finish y" do
      expect(Line.new(0, 1, 1, 0).points).to eq([Point.new(0, 1), Point.new(1, 0)])
    end

    it "returns the points in a diagonal line, start x > finish x & start y < finish y" do
      expect(Line.new(1, 0, 0, 1).points).to eq([Point.new(1, 0), Point.new(0, 1)])
    end

    it "returns the points in a diagonal line, start x > finish x & start y > finish y" do
      expect(Line.new(1, 1, 0, 0).points).to eq([Point.new(1, 1), Point.new(0, 0)])
    end

  end
end
