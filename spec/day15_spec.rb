require_relative "../lib/day15.rb"

describe Cave do
  describe '#lowest_risk' do
    let(:example_risk) do
      risk '
        1163751742
        1381373672
        2136511328
        3694931569
        7463417111
        1319128137
        1359912421
        3125421639
        1293138521
        2311944581
      '
    end

    let(:puzzle_risk) { IO.readlines('spec/day15_input.txt').map { |line| line.chomp.chars.map &:to_i } }

    it "finds the total risk of the path with the lowest risk 1" do
      risk = risk '
        12
        11
      '
      expect_lowest_risk risk, 2
    end

    it "finds the total risk of the path with the lowest risk 2" do
      risk = risk '
        121
        111
        121
      '
      expect_lowest_risk risk, 4
    end

    it "moves up if necessary" do
      risk = risk '
        19999
        19111
        11191
      '
      expect_lowest_risk risk, 8
    end

    it "moves left if necessary" do
      risk = risk '
        111
        991
        911
        919
        911
      '
      expect_lowest_risk risk, 8
    end

    it "replicates the example untiled" do
      expect_lowest_risk example_risk, 40
    end

    it "solves the puzzle untiled" do
      expect_lowest_risk puzzle_risk, 745
    end

    it "replicates the example tiled 5x5" do
      expect_lowest_risk tile_5x5(example_risk), 315
    end

    xit "solves the puzzle tiled 5x5" do
      expect_lowest_risk tile_5x5(puzzle_risk), 3002
    end

    def expect_lowest_risk(risk, expected_risk)
      expect(Cave.new(risk).lowest_risk).to eq(expected_risk)
    end

  end

  describe '#tile5x5' do
    it "tiles per the second puzzle" do
      tile = risk '
        123
        456
        789
      '
      tiled_risk = risk '
        123234345456567
        456567678789891
        789891912123234
        234345456567678
        567678789891912
        891912123234345
        345456567678789
        678789891912123
        912123234345456
        456567678789891
        789891912123234
        123234345456567
        567678789891912
        891912123234345
        234345456567678
      '
      expect(tile_5x5(tile)).to eq(tiled_risk)
    end
  end

  def risk(lines)
    lines.strip.split("\n").map { |line| line.strip.chars.map &:to_i }
  end

  def tile_5x5(values)
    5.times.flat_map { |i| values.map { |row| increment row, i } }. # tile in y
    map { |row| 5.times.flat_map { |i| increment row, i } }       # tile in x
  end

  def increment(row, i)
    row.map do |value|
      value += i
      if value > 9
        value -= 9
      end
      value
    end
  end

end

describe PriorityQueue do
  describe '.new' do
    it "creates an empty queue" do
      expect(PriorityQueue.new.elements).to be_empty
    end

    it "adds elements to the queue" do
      expect(PriorityQueue.new([["b", 2], ["c", 3], ["a", 1]]).elements).to eq([["a", 1], ["c", 3], ["b", 2]])
    end

  end

  describe '#add' do
    it "adds a first element" do
      q = PriorityQueue.new
      q.add "foo", 1
      expect(q.elements).to eq([["foo", 1]])
    end

    it "adds a second element" do
      q = PriorityQueue.new
      q.add "foo", 2
      q.add "bar", 1
      expect(q.elements).to eq([["bar", 1], ["foo", 2]])
    end

  end

  describe '#lower' do
    it "lowers the priority of an element" do
      q = PriorityQueue.new [["a", 1], ["b", 2], ["c", 3]]
      q.lower "b", 0
      expect(q.elements).to eq([["b", 0], ["a", 1], ["c", 3]])
    end
  end

  describe '#pop' do
    it "deletes and returns the lowest-priority element" do
      q = PriorityQueue.new
      q.add "b", 2
      q.add "a", 1
      expect(q.pop).to eq(["a", 1])
      expect(q.elements).to eq([["b", 2]])
    end

    it "moves the last element under the root's smallest child" do
      q = PriorityQueue.new [["a", 1], ["c", 3], ["b", 2], ["d", 4]]
      expect(q.pop).to eq(["a", 1])
      expect(q.elements).to eq([["b", 2], ["c", 3], ["d", 4]])
    end

  end

  describe '#include?' do
    it "returns true if the given value is in the queue" do
      q = PriorityQueue.new [["a", 1]]
      expect(q.include? "a").to be_truthy
    end

    it "returns false if the given value is not in the queue" do
      q = PriorityQueue.new [["a", 1]]
      expect(q.include? "b").to be_falsey
    end

    it "reflects deletion" do
      q = PriorityQueue.new [["a", 1], ["b", 2]]
      q.pop
      expect(q.include? "a").to be_falsey
    end

  end

end
