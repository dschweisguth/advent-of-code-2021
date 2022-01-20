require_relative "../lib/day14.rb"

describe Polymerizer do
  let(:example_template_and_rules) do
    input <<~END.split "\n"
        NNCB
        
        CH -> B
        HH -> N
        CB -> H
        NH -> C
        HB -> C
        HC -> B
        HN -> C
        NN -> C
        BH -> H
        NC -> B
        NB -> B
        BN -> B
        BB -> N
        BC -> B
        CC -> N
        CN -> C
    END
  end

  describe '#polymerize' do
    it "polymerizes one step" do
      polymerizer = Polymerizer.new ['AB -> C']
      expect(polymerizer.polymerize 'AB').to eq('ACB')
    end

    it "polymerizes two steps" do
      polymerizer = Polymerizer.new ['AB -> C', 'AC -> D', 'CB -> E']
      expect(polymerizer.polymerize 'AB', 2).to eq('ADCEB')
    end

    it "replicates the example" do
      template, rules = example_template_and_rules
      expect(Polymerizer.new(rules).polymerize template, 4).to eq('NBBNBNBBCCNBCNCCNBBNBBNBBBNBBNBBCBHCBHHNHCBBCBHCB')
    end

  end

  describe '#signature' do
    let(:puzzle_template_and_rules) { input IO.readlines('spec/day14_input.txt').map(&:chomp) }

    it "returns the quantity of the most common element - the quantity of the least common element" do
      expect(Polymerizer.new([]).signature 'ABAA').to eq(2)
    end

    it "polymerizes the given number of steps" do
      expect(Polymerizer.new(['AB -> C']).signature 'ABBAA', 1).to eq(2)
    end

    it "replicates the example after 10 steps" do
      template, rules = example_template_and_rules
      expect(Polymerizer.new(rules).signature template, 10).to eq(1588)
    end

    it "solves the puzzle after 10 steps" do
      template, rules = puzzle_template_and_rules
      expect(Polymerizer.new(rules).signature template, 10).to eq(2447)
    end

    it "replicates the example after 40 steps" do
      template, rules = example_template_and_rules
      expect(Polymerizer.new(rules).signature template, 40).to eq(2188189693529)
    end

    it "solves the puzzle after 40 steps" do
      template, rules = puzzle_template_and_rules
      expect(Polymerizer.new(rules).signature template, 40).to eq(3018019237563)
    end

  end

  def input(lines)
    template = lines.shift
    while lines.first.empty?
      lines.shift
    end
    [template, lines]
  end

end
