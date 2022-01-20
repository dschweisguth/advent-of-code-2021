require_relative "../lib/day11.rb"

describe Octopuses do
  describe '#wait' do
    it "increases the energy level of each octopus by 1" do
      expect_wait_to_change_levels [[0]], [[1]], 0
    end

    [
      [
        [[9]],
        [[0]],
        1
      ],
      [
        [[9, 0]],
        [[0, 2]],
        1
      ],
      [
        [[0, 9]],
        [[2, 0]],
        1
      ],
      [
        [
          [9],
          [0]
        ],
        [
          [0],
          [2]
        ],
        1
      ],
      [
        [
          [0],
          [9]
        ],
        [
          [2],
          [0]
        ],
        1
      ],
      [
        [
          [9, 0],
          [0, 0],
        ], [
          [0, 2],
          [2, 2],
        ],
        1
      ],
      [
        [
          [0, 9],
          [0, 0],
        ], [
          [2, 0],
          [2, 2],
        ],
        1
      ],
      [
        [
          [0, 0],
          [9, 0],
        ], [
          [2, 2],
          [0, 2],
        ],
        1
      ],
      [
        [
          [0, 0],
          [0, 9],
        ], [
          [2, 2],
          [2, 0],
        ],
        1
      ],
    ].each do |levels, expected_levels, expected_flashes|
      it "causes an energy-9 octopus to flash" do
        expect_wait_to_change_levels levels, expected_levels, expected_flashes
      end
    end

    it "replicates 10 steps of the example" do
      example_levels = levels '
        5483143223
        2745854711
        5264556173
        6141336146
        6357385478
        4167524645
        2176841721
        6882881134
        4846848554
        5283751526
      '
      expected_levels = levels '
        0481112976
        0031112009
        0041112504
        0081111406
        0099111306
        0093511233
        0442361130
        5532252350
        0532250600
        0032240000
      '
      octopuses = Octopuses.new example_levels
      flashes = 10.times.map { octopuses.wait }.sum
      expect(octopuses.levels).to eq(expected_levels)
      expect(flashes).to eq(204)
    end

    let(:puzzle_levels) do
      levels '
        4525436417
        1851242553
        5421435521
        8431325447
        4517438332
        3521262111
        3331541734
        4351836641
        2753881442
        7717616863
      '
    end

    it "counts the flashes over 100 steps" do
      octopuses = Octopuses.new puzzle_levels
      flashes = 100.times.map { octopuses.wait }.sum
      expect(flashes).to eq(1652)
    end

    it "finds the step during which all octopuses flash" do
      octopuses = Octopuses.new puzzle_levels
      steps = 1
      loop do
        flashes = octopuses.wait
        if flashes == 100
          break
        end
        steps += 1
      end
      expect(steps).to eq(220)
    end

    def levels(string)
      string.strip.split(/\s+/).map { |line| line.chars.map &:to_i  }
    end

    def expect_wait_to_change_levels(levels, expected_levels, expected_flashes)
      octopuses = Octopuses.new levels
      flashes = octopuses.wait
      expect(octopuses.levels).to eq(expected_levels)
      expect(flashes).to eq(expected_flashes)
    end

  end

end
