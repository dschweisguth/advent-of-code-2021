require_relative "../lib/day25.rb"

describe Seafloor do
  let(:example_map) do
    %w[
        v...>>.vv>
        .vv>>.vv..
        >>.>v>...v
        >>v>>.>.v.
        v>v.vv.v..
        >.>>..v...
        .vv..>.>v.
        v.v..>>v.v
        ....v..v.>
      ]
  end

  describe '#settle' do
    it "steps until no cukes can move" do
      expect_settle ['>'], 1
    end

    it "steps as many times as necessary" do
      expect_settle ['>..v'], 3
    end

    it "replicates the example" do
      expect_settle example_map, 58
    end

    it "solves the puzzle" do
      puzzle_map = IO.readlines('spec/day25_input.txt').map &:strip
      expect_settle puzzle_map, 528
    end

    def expect_settle(map, step_count)
      expect(described_class.new(map).settle).to eq(step_count)
    end

  end

  describe '#step' do
    it "returns false if no cukes move" do
      expect_step %w[>v. .>v v.>], false, %w[>v. .>v v.>]
    end

    it "moves an E cuke east" do
      expect_step ['>.'], true, ['.>']
    end

    it "moves an E cuke through the edge of the map" do
      expect_step ['.>'], true, ['>.']
    end

    it "doesn't move a blocked E cuke not at the edge of the map" do
      expect_step ['>>.'], true, ['>.>']
    end

    it "doesn't move a blocked E cuke at the edge of the map" do
      expect_step ['>.>'], true, ['.>>']
    end

    it "moves E cukes in every row" do
      expect_step %w[>... ..>.], true, %w[.>.. ...>]
    end

    it "moves an S cuke south" do
      expect_step %w[v .], true, %w[. v]
    end

    it "moves an S cuke through the edge of the map" do
      expect_step %w[. v], true, %w[v .]
    end

    it "doesn't move a blocked S cuke not at the edge of the map" do
      expect_step %w[v v .], true, %w[v . v]
    end

    it "doesn't move a blocked S cuke at the edge of the map" do
      expect_step %w[v . v], true, %w[. v v]
    end

    it "moves S cukes in every column" do
      expect_step %w[v. .. .v ..], true, %w[.. v. .. .v]
    end

    it "replicates example step 1" do
      expected_map = %w[
        ....>.>v.>
        v.v>.>v.v.
        >v>>..>v..
        >>v>v>.>.v
        .>v.v...v.
        v>>.>vvv..
        ..v...>>..
        vv...>>vv.
        >.v.v..v.v
      ]
      expect_step example_map, true, expected_map
    end

    def expect_step(map, expected_moved, expected_map)
      seafloor = described_class.new(map)
      expect(seafloor.step).to eq(expected_moved)
      expect(seafloor.map).to eq(expected_map)
    end

  end

end
