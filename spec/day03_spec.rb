require_relative "../lib/day03.rb"

describe Day03 do
  let(:example_points) do
    %w[
      00100
      11110
      10110
      10111
      10101
      01111
      00111
      11100
      10000
      11001
      00010
      01010
    ]
  end

  let(:puzzle_points) { IO.readlines 'spec/day03_input.txt' }

  describe '#gamma_rate' do
    it "calculates the rate from a single point" do
      expect(subject.gamma_rate %w[0]).to eq(0)
    end

    it "calculates the rate from two points, rounding up" do
      expect(subject.gamma_rate %w[010 011]).to eq("011".to_i 2)
    end

    it "solves the puzzle" do
      expect(subject.gamma_rate puzzle_points).to eq(190)
    end

  end

  describe '#epsilon_rate' do
    it "calculates the rate from a single point" do
      expect(subject.epsilon_rate %w[0]).to eq(1)
    end

    it "calculates the rate from two points, rounding down" do
      expect(subject.epsilon_rate %w[010 011]).to eq("100".to_i 2)
    end

    it "solves the puzzle" do
      expect(subject.epsilon_rate puzzle_points).to eq(3905)
    end

  end

  describe '#oxygen_generator_rating' do
    it "calculates the rating from a single point" do
      expect(subject.oxygen_generator_rating %w[0]).to eq(0)
    end

    it "calculates the rating from two points differing in the first bit" do
      expect(subject.oxygen_generator_rating %w[0 1]).to eq("1".to_i 2)
    end

    it "calculates the rating from two points differing in the second bit" do
      expect(subject.oxygen_generator_rating %w[10 11]).to eq("11".to_i 2)
    end

    it "replicates the example" do
      expect(subject.oxygen_generator_rating example_points).to eq(23)
    end

    it "solves the puzzle" do
      expect(subject.oxygen_generator_rating puzzle_points).to eq(282)
    end

  end

  describe '#co2_scrubber_rating' do
    it "calculates the rating from a single point" do
      expect(subject.co2_scrubber_rating %w[0]).to eq(0)
    end

    it "calculates the rating from points differing in the first bit" do
      expect(subject.co2_scrubber_rating %w[0 1]).to eq("0".to_i 2)
    end

    it "calculates the rating from points differing in the second bit" do
      expect(subject.co2_scrubber_rating %w[00 01 10 11]).to eq("00".to_i 2)
    end

    it "replicates the example" do
      expect(subject.co2_scrubber_rating example_points).to eq(10)
    end

    it "solves the puzzle" do
      expect(subject.co2_scrubber_rating puzzle_points).to eq(3205)
    end

  end

  describe '#frequencies' do
    it "tallies 1 point" do
      expect(subject.frequencies [[0]]).to eq([0])
    end

    it "tallies the puzzle" do
      expect(subject.frequencies subject.to_bits puzzle_points).to eq([499, 489, 498, 490, 502, 484, 515, 508, 502, 518, 517, 487])
    end

  end

end
