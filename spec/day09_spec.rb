require_relative "../lib/day09.rb"

describe Map do
  let(:example_locations) do
    locations <<~END.split("\n")
      2199943210
      3987894921
      9856789892
      8767896789
      9899965678
    END
  end

  let(:puzzle_locations) do
    locations IO.readlines('spec/day09_input.txt').map(&:strip)
  end

  def locations(lines)
    lines.map { |row| row.chars.map { |char| Integer char } }
  end

  describe '#low_point_risk_level_sum' do
    it "sums low points" do
      map = Map.new [
        [0, 1],
        [1, 0]
      ]
      expect(map.low_point_risk_level_sum).to eq(2)
    end

    it "replicates the example" do
      expect(Map.new(example_locations).low_point_risk_level_sum).to eq(15)
    end

    it "solves the puzzle" do
      expect(Map.new(puzzle_locations).low_point_risk_level_sum).to eq(456)
    end

  end

  describe '#low_points' do
    [
      [
        [[0, 0]],
        [
          [0, 1, 0],
          [1, 0, 0],
          [0, 0, 0]
        ]
      ],
      [
        [[1, 0]],
        [
          [1, 0, 1],
          [0, 1, 0],
          [0, 0, 0]
        ]
      ],
      [
        [[2, 0]],
        [
          [0, 1, 0],
          [0, 0, 1],
          [0, 0, 0]
        ]
      ],
      [
        [[0, 1]],
        [
          [1, 0, 0],
          [0, 1, 0],
          [1, 0, 0]
        ]
      ],
      [
        [[0, 0], [2, 0], [1, 1], [0, 2], [2, 2]],
        [
          [0, 1, 0],
          [1, 0, 1],
          [0, 1, 0]
        ]
      ],
      [
        [[2, 1]],
        [
          [0, 0, 1],
          [0, 1, 0],
          [0, 0, 1]
        ]
      ],
      [
        [[0, 2]],
        [
          [0, 0, 0],
          [1, 0, 0],
          [0, 1, 0]
        ]
      ],
      [
        [[1, 2]],
        [
          [0, 0, 0],
          [0, 1, 0],
          [1, 0, 1]
        ]
      ],
      [
        [[2, 2]],
        [
          [0, 0, 0],
          [0, 0, 2],
          [0, 2, 0]
        ]
      ],
    ].each do |locations, map|
      it "finds a low point at #{locations}" do
        expect(Map.new(map).low_points).to match_array(locations)
      end
    end
  end

  describe '#largest_basins_product' do
    it "returns the product of the size of the 3 largest basins" do
      locations = [
        [0, 0, 9, 9, 9, 9, 9],
        [9, 9, 0, 0, 0, 9, 9],
        [9, 9, 9, 9, 9, 9, 9],
        [0, 0, 0, 0, 0, 9, 9],
        [9, 9, 9, 9, 9, 9, 9],
        [0, 0, 0, 0, 0, 0, 0],
      ]
      expect(Map.new(locations).largest_basins_product).to eq(105)
    end

    it "replicates the example" do
      expect(Map.new(example_locations).largest_basins_product).to eq(1134)
    end

    xit "solves the puzzle" do
      expect(Map.new(puzzle_locations).largest_basins_product).to eq(1047744)
    end

  end

  describe '#basins' do
    it "finds the simplest possible basin" do
      expect(Map.new([[0, 9]]).basins).to eq([[[0, 0]]])
    end

    it "finds a two-location basin" do
      expect(Map.new([[0, 0, 9]]).basins).to match_array([[[0, 0], [1, 0]]])
    end

  end

end
