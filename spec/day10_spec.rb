require_relative "../lib/day10.rb"

describe Day10 do
  let(:example_lines) do
    <<~END.split "\n"
      [({(<(())[]>[[{[]{<()<>>
      [(()[<>])]({[<{<<[]>>(
      {([(<{}[<>[]}>{[]{[(<()>
      (((({<>}<{<{<>}{[]{[]{}
      [[<[([]))<([[{}[[()]]]
      [{[{({}]{}}([{[{{{}}([]
      {<[[]]>}<{[{[{[]{()[[[]
      [<(<(<(<{}))><([]([]()
      <{([([[(<>()){}]>(<<{{
      <{([{{}}[<[[[<>{}]]]>[]]
    END
  end

  let(:puzzle_lines) { IO.readlines('spec/day10_input.txt').map &:strip }

  describe '#corruption_score' do
    it "returns 0 for a valid line ()" do
      expect(subject.corruption_score ['()']).to eq(0)
    end

    it "returns 0 for an incomplete line (" do
      expect(subject.corruption_score ['(']).to eq(0)
    end

    [
      ['[)', 3],
      ['(]', 57],
      ['<}', 1197],
      ['{>', 25137]
    ].each do |line, score|
      it "returns #{score} for a single corrupt line #{line}" do
        expect(subject.corruption_score [line]).to eq(score)
      end
    end

    it "replicates the example" do
      expect(subject.corruption_score example_lines).to eq(26397)
    end

    it "solves the puzzle" do
      expect(subject.corruption_score puzzle_lines).to eq(442131)
    end

  end

  describe '#incompleteness_score' do
    it "returns 0 for a valid line ()" do
      expect(subject.incompleteness_score ['()']).to eq(0)
    end

    it "returns 0 for a corrupt line (]" do
      expect(subject.incompleteness_score ['(]']).to eq(0)
    end

    [
      ['(', 1],
      ['[', 2],
      ['{', 3],
      ['<', 4]
    ].each do |line, score|
      it "returns #{score} for a single incomplete line #{line}" do
        expect(subject.incompleteness_score [line]).to eq(score)
      end
    end

    it "multiplies the score by 5 before adding the second and later incompletenesses" do
      expect(subject.incompleteness_score ['([']).to eq(11)
    end

    it "replicates the example" do
      expect(subject.incompleteness_score example_lines).to eq(288957)
    end

    it "solves the puzzle" do
      expect(subject.incompleteness_score puzzle_lines).to eq(3646451424)
    end

  end

end
