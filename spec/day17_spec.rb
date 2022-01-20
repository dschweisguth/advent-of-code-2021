require_relative "../lib/day17.rb"

describe Day17 do
  let(:example_target) { [[20, -10], [30, -5]] }
  let(:puzzle_target) { [[79, -176], [137, -117]] }
  let(:user_contributed_target) { [[352, -49], [377, -30]] }
  let(:part_3_example_target) { [[20000, -10000], [30000, -5000]] }

  describe '#zenith' do
    it "returns the maximum altitude reached by any trajectory that hits the target" do
      expect(subject.zenith [[1, -1], [1, -1]]).to eq(0) # vx = 1, vy = -1 and vx = 1, vy = 0 hit the target
    end

    it "returns the expected result for a target with a different zenith" do
      expect(subject.zenith [[1, -2], [1, -2]]).to eq(1) # vx = 1, vy = -2 and vx = 1, vy = 1 hit the target
    end

    it "replicates the example" do
      expect(subject.zenith example_target).to eq(45)
    end

    it "solves the puzzle" do
      expect(subject.zenith puzzle_target).to eq(15400)
    end

    it "solves this user-contributed input" do
      expect(subject.zenith user_contributed_target).to eq(66)
    end

  end

  describe '#hit_count' do
    it "returns the expected result for a simple case" do
      expect(subject.hit_count [[1, -1], [1, -1]]).to eq(2) # vx = 1, vy = -1 and vx = 1, vy = 0 hit the target
    end

    it "replicates the example" do
      expect(subject.hit_count example_target).to eq(112)
    end

    it "solves the puzzle" do
      expect(subject.hit_count puzzle_target).to eq(5844)
    end

    it "solves this user-contributed input" do
      expect(subject.hit_count user_contributed_target).to eq(820)
    end

    xit "solves the part 3 example" do
      expect(subject.zenith part_3_example_target).to eq(74743399)
    end

  end

end
