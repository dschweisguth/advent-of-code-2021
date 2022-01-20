require_relative "../lib/day02.rb"

describe Day02 do
  let(:puzzle_movements) { IO.readlines 'spec/day02_input.txt' }

  describe '#plot' do
    it "plots no movements" do
      expect(subject.plot []).to eq(Position.new 0, 0)
    end

    it "plots a forward movement" do
      expect(subject.plot ["forward 1"]).to eq(Position.new 1, 0)
    end

    it "plots a down movement" do
      expect(subject.plot ["down 1"]).to eq(Position.new 0, 1)
    end

    it "plots an up movement" do
      expect(subject.plot ["up 1"]).to eq(Position.new 0, -1) # can subs fly?
    end

    it "solves the puzzle" do
      expect(subject.plot puzzle_movements).to eq(Position.new 1980, 866)
    end

  end

  describe '#plot2' do
    it "plots no movements" do
      expect(subject.plot2 []).to eq(Position2.new 0, 0, 0)
    end

    it "plots a forward movement with aim 0" do
      expect(subject.plot2 ["forward 1"]).to eq(Position2.new 1, 0, 0)
    end

    it "plots a forward movement with nonzero aim" do
      expect(subject.plot2 ["down 1", "forward 5"]).to eq(Position2.new 5, 5, 1)
    end

    it "plots a down movement" do
      expect(subject.plot2 ["down 1"]).to eq(Position2.new 0, 0, 1)
    end

    it "plots an up movement" do
      expect(subject.plot2 ["up 1"]).to eq(Position2.new 0, 0, -1)
    end

    it "solves the puzzle" do
      expect(subject.plot2 puzzle_movements).to eq(Position2.new 1980, 991459, 866)
    end

  end
end
