require_relative "../lib/day20.rb"

describe MatrixEnhancer do
  let(:example_algorithm) { "..#.#..#####.#.#.#.###.##.....###.##.#..###.####..#####..#....#..#..##..###..######.###...####..#..#####..##..#.#####...##.#.#..#.##..#.#......#.###.######.###.####...#.##.##..#..#..#####.....#.#....###..#.##......#.....#..#..#..##..#...##.######.####.####.#.#...#.......#..#.#.#...####.##.#......#..#...##.#.##..#...##.#.##..###.#......#.#.......#.#.#.####.###.##...#.....####.#..#..#.##.#....##..#.####....##...##..#...#......#.#.......#.......##..####..#...#.#.#...##..#.#..###..#####........#..####......#..#" }
  let(:example_image) do
    <<~END.split "\n"
        #..#.
        #....
        ##..#
        ..#..
        ..###
    END
  end

  describe '#enhance' do
    it "enhances when edges stay dark" do
      algorithm = ('.' * 512).tap { |a| [2, 16, 128].each { |n| a[n] = '#' }  }
      image = <<~END.split "\n"
        ...
        .#.
        ...
      END
      expected_image = <<~END.split "\n"
        .......
        .......
        ...#...
        ...#...
        ...#...
        .......
        .......
      END
      expect_enhance algorithm, image, 1, expected_image
    end

    it "enhances when edges can light" do
      algorithm = '#' * 512
      image = <<~END.split "\n"
        ###
        ###
        ###
      END
      expected_image = <<~END.split "\n"
        #######
        #######
        #######
        #######
        #######
        #######
        #######
      END
      expect_enhance algorithm, image, 1, expected_image
    end

    it "enhances twice when edges stay dark" do
      algorithm = ('.' * 512).tap { |a| [2, 16, 18, 128, 144, 146].each { |n| a[n] = '#' }  }
      image = <<~END.split "\n"
        ...
        .#.
        ...
      END
      expected_image = <<~END.split "\n"
        .........
        .........
        ....#....
        ....#....
        ....#....
        ....#....
        ....#....
        .........
        .........
      END
      expect_enhance algorithm, image, 2, expected_image
    end

    it "enhances a horizontally asymmetric image" do
      algorithm = ('.' * 512).tap { |a| [2, 16, 128].each { |n| a[n] = '#' }  }
      image = <<~END.split "\n"
        ...
        #..
        ...
      END
      expected_image = <<~END.split "\n"
        .......
        .......
        ..#....
        ..#....
        ..#....
        .......
        .......
      END
      expect_enhance algorithm, image, 1, expected_image
    end

    it "enhances twice when edges can light" do
      algorithm = ('#' * 512).tap { |a| [511].each { |n| a[n] = '.' }  }
      image = <<~END.split "\n"
        ...
        ...
        ...
      END
      expected_image = <<~END.split "\n"
        .........
        .........
        .........
        .........
        .........
        .........
        .........
        .........
        .........
      END
      expect_enhance algorithm, image, 2, expected_image
    end

    it "replicates the example after 1 round" do
      expected_image = <<~END.split "\n"
        .........
        ..##.##..
        .#..#.#..
        .##.#..#.
        .####..#.
        ..#..##..
        ...##..#.
        ....#.#..
        .........
      END
      expect_enhance example_algorithm, example_image, 1, expected_image
    end

    def expect_enhance(algorithm, image, rounds, expected_image)
      expect(described_class.new(algorithm).enhance image, rounds).to eq(expected_image)
    end

  end

  describe '#enhanced_pixel_count' do
    let(:puzzle_algorithm) { "#...####.......###.#..#.####.#.######.####..##...###..####.#..###..#.#.#.###.#.###..#...##..#...#...##.###.####..#..#...####..#..#.#.###.#..#....###.#....#.##...#..###....#####..#...#..#..#.#.##..#.##....##.##.##..######.#....#...#.........###...##.##..####.##....#####...#...#.##....#..##.##..#.###.#####.#####.#####...##.#.#####.....#.##.##..#..#...##.#....#..##.#.###.##....#.#..######..#.#.##.#.##...###..#..#.#.#...###...###.##..#.....###########.#....#....#...#.##.##.###....#...##....##..#..###.##..#.#..." }
    let(:puzzle_image) { IO.readlines('spec/day20_input.txt').map &:strip }

    it "returns the number of pixels in the enhanced image" do
      algorithm = ('.' * 512).tap { |a| [2, 16, 128].each { |n| a[n] = '#' }  }
      image = <<~END.split "\n"
        ...
        .#.
        ...
      END
      expect_enhanced_pixel_count algorithm, image, 1, 3
    end

    it "replicates the example" do
      expect_enhanced_pixel_count example_algorithm, example_image, 2, 35
    end

    xit "replicates part 2 of the example" do
      expect_enhanced_pixel_count example_algorithm, example_image, 50, 3351
    end

    it "solves the puzzle after 2 rounds" do
      expect_enhanced_pixel_count puzzle_algorithm, puzzle_image, 2, 5349
    end

    xit "solves the puzzle after 50 rounds" do
      expect_enhanced_pixel_count puzzle_algorithm, puzzle_image, 50, 15806
    end

    def expect_enhanced_pixel_count(algorithm, image, rounds, expected_count)
      expect(described_class.new(algorithm).enhanced_pixel_count image, rounds).to eq(expected_count)
    end

  end

end
