require_relative "../lib/day24.rb"

describe "ALUs" do
  shared_examples "ALU" do
    describe '#valid_number' do
      let(:puzzle_program) { IO.readlines('spec/day24_input.txt').map &:strip }

      it "solves puzzle 1" do
        expect_valid_number(97919997299495) { |candidate, current_best| candidate > current_best }
      end

      it "solves puzzle 2" do
        expect_valid_number(51619131181131) { |candidate, current_best| candidate < current_best }
      end

      def expect_valid_number(expected_number, &criterion)
        expect(described_class.new(puzzle_program).valid_number &criterion).to eq(expected_number)
      end

    end

  end

  xdescribe LiteralALU do
    it_behaves_like "ALU"
  end

  xdescribe SuccinctALU do
    it_behaves_like "ALU"
  end

  describe OptimizedALU do
    it_behaves_like "ALU"
  end

end
