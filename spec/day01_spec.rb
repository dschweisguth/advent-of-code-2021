require_relative "../lib/day01.rb"

describe Day01 do
  describe '#increases' do
    let(:puzzle_values) { IO.readlines('spec/day01_input.txt').map { |line| Integer(line) } }

    context "window length 1" do
      let(:window) { 1 }

      (0..1).to_a.each do |n|
        it "counts 0 increases in #{n} values" do
          expect_to_increase (0..n - 1).to_a, times: 0
        end
      end

      it "counts a single increase" do
        expect_to_increase [0, 1], times: 1
      end

      it "solves the puzzle" do
        expect_to_increase puzzle_values, times: 1713
      end

    end

    context "window length 3" do
      let(:window) { 3 }

      (0..3).to_a.each do |n|
        it "counts 0 increases in #{n} values" do
          expect_to_increase (0..n - 1).to_a, times: 0
        end
      end

      it "counts a single increase" do
        expect_to_increase [0, 0, 0, 1], times: 1
      end

      it "solves the puzzle" do
        expect_to_increase puzzle_values, times: 1734
      end

    end

    def expect_to_increase(measurements, times:)
      expect(subject.increases measurements, window: window).to eq(times)
    end

  end

end
