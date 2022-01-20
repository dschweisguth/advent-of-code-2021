require_relative "../lib/day08.rb"

describe Day08 do
  let(:ten_entry_example) do
    <<~END.split "\n"
      be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe
      edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc
      fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg
      fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb
      aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea
      fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb
      dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe
      bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef
      egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb
      gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce
    END
  end

  let(:puzzle) { IO.readlines "spec/day08_input.txt" }

  describe '#easy_digit_count' do
    [
      [2, "ab ab ab ab ab ab ab ab ab ab | ab abcde abcde abcde"],
      [3, "ab ab ab ab ab ab ab ab ab ab | abc abcde abcde abcde"],
      [4, "ab ab ab ab ab ab ab ab ab ab | abcd abcde abcde abcde"],
      [7, "ab ab ab ab ab ab ab ab ab ab | abcdefg abcde abcde abcde"],
    ].each do |digit_count, entry|
      it "counts a #{digit_count}-segment output digit" do
        expect(subject.easy_digit_count [entry]).to eq(1)
      end
    end

    it "does not count a 5- or 6-segment output digit " do
      expect(subject.easy_digit_count ["ab ab ab ab ab ab ab ab ab ab | abcde abcde abcde abcdef"]).to eq(0)
    end

    it "replicates the ten-line example" do
      expect(subject.easy_digit_count ten_entry_example).to eq(26)
    end

    it "solves the puzzle" do
      expect(subject.easy_digit_count puzzle).to eq(445)
    end

  end

  describe '#output_sum' do
    it "replicates the one-entry example" do
      one_entry_example = ["acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"]
      expect(subject.output_sum one_entry_example).to eq(5353)
    end

    it "replicates the ten-entry example" do
      expect(subject.output_sum ten_entry_example).to eq(61229)
    end

    it "solves the puzzle" do
      expect(subject.output_sum ten_entry_example).to eq(61229)
    end

    it "solves the puzzle" do
      expect(subject.output_sum puzzle).to eq(1043101)
    end

  end

end
