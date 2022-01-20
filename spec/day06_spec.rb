require_relative "../lib/day06.rb"

describe School do
  describe '#develop' do
    it "ages a fish a day" do
      school = School.new [1]
      school.develop 1
      expect(school).to eq(School.new [0])
    end

    it "reproduces a 0-day fish" do
      school = School.new [0]
      school.develop 1
      expect(school).to eq(School.new [6, 8])
    end

    it "develops for the given number of days" do
      school = School.new [1]
      school.develop 2
      expect(school).to eq(School.new [6, 8])
    end

    it "handles 0- and 7-day fish present at the same time" do
      school = School.new [0, 7]
      school.develop 1
      expect(school).to eq(School.new [6, 6, 8])
    end

    it "replicates example result 1" do
      school = School.new [3, 4, 3, 1, 2]
      school.develop 18
      expect(school.count).to eq(26)
    end

    it "replicates example result 2" do
      school = School.new [3, 4, 3, 1, 2]
      school.develop 80
      expect(school.count).to eq(5934)
    end

    it "solves puzzle result 1" do
      school = School.new [1, 1, 1, 3, 3, 2, 1, 1, 1, 1, 1, 4, 4, 1, 4, 1, 4, 1, 1, 4, 1, 1, 1, 3, 3, 2, 3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 3, 4, 1, 1, 4, 3, 1, 2, 3, 1, 1, 1, 5, 2, 1, 1, 1, 1, 2, 1, 2, 5, 2, 2, 1, 1, 1, 3, 1, 1, 1, 4, 1, 1, 1, 1, 1, 3, 3, 2, 1, 1, 3, 1, 4, 1, 2, 1, 5, 1, 4, 2, 1, 1, 5, 1, 1, 1, 1, 4, 3, 1, 3, 2, 1, 4, 1, 1, 2, 1, 4, 4, 5, 1, 3, 1, 1, 1, 1, 2, 1, 4, 4, 1, 1, 1, 3, 1, 5, 1, 1, 1, 1, 1, 3, 2, 5, 1, 5, 4, 1, 4, 1, 3, 5, 1, 2, 5, 4, 3, 3, 2, 4, 1, 5, 1, 1, 2, 4, 1, 1, 1, 1, 2, 4, 1, 2, 5, 1, 4, 1, 4, 2, 5, 4, 1, 1, 2, 2, 4, 1, 5, 1, 4, 3, 3, 2, 3, 1, 2, 3, 1, 4, 1, 1, 1, 3, 5, 1, 1, 1, 3, 5, 1, 1, 4, 1, 4, 4, 1, 3, 1, 1, 1, 2, 3, 3, 2, 5, 1, 2, 1, 1, 2, 2, 1, 3, 4, 1, 3, 5, 1, 3, 4, 3, 5, 1, 1, 5, 1, 3, 3, 2, 1, 5, 1, 1, 3, 1, 1, 3, 1, 2, 1, 3, 2, 5, 1, 3, 1, 1, 3, 5, 1, 1, 1, 1, 2, 1, 2, 4, 4, 4, 2, 2, 3, 1, 5, 1, 2, 1, 3, 3, 3, 4, 1, 1, 5, 1, 3, 2, 4, 1, 5, 5, 1, 4, 4, 1, 4, 4, 1, 1, 2]
      school.develop 80
      expect(school.count).to eq(372984)
    end

    it "solves puzzle result 2" do
      school = School.new [1, 1, 1, 3, 3, 2, 1, 1, 1, 1, 1, 4, 4, 1, 4, 1, 4, 1, 1, 4, 1, 1, 1, 3, 3, 2, 3, 1, 2, 1, 1, 1, 1, 1, 1, 1, 3, 4, 1, 1, 4, 3, 1, 2, 3, 1, 1, 1, 5, 2, 1, 1, 1, 1, 2, 1, 2, 5, 2, 2, 1, 1, 1, 3, 1, 1, 1, 4, 1, 1, 1, 1, 1, 3, 3, 2, 1, 1, 3, 1, 4, 1, 2, 1, 5, 1, 4, 2, 1, 1, 5, 1, 1, 1, 1, 4, 3, 1, 3, 2, 1, 4, 1, 1, 2, 1, 4, 4, 5, 1, 3, 1, 1, 1, 1, 2, 1, 4, 4, 1, 1, 1, 3, 1, 5, 1, 1, 1, 1, 1, 3, 2, 5, 1, 5, 4, 1, 4, 1, 3, 5, 1, 2, 5, 4, 3, 3, 2, 4, 1, 5, 1, 1, 2, 4, 1, 1, 1, 1, 2, 4, 1, 2, 5, 1, 4, 1, 4, 2, 5, 4, 1, 1, 2, 2, 4, 1, 5, 1, 4, 3, 3, 2, 3, 1, 2, 3, 1, 4, 1, 1, 1, 3, 5, 1, 1, 1, 3, 5, 1, 1, 4, 1, 4, 4, 1, 3, 1, 1, 1, 2, 3, 3, 2, 5, 1, 2, 1, 1, 2, 2, 1, 3, 4, 1, 3, 5, 1, 3, 4, 3, 5, 1, 1, 5, 1, 3, 3, 2, 1, 5, 1, 1, 3, 1, 1, 3, 1, 2, 1, 3, 2, 5, 1, 3, 1, 1, 3, 5, 1, 1, 1, 1, 2, 1, 2, 4, 4, 4, 2, 2, 3, 1, 5, 1, 2, 1, 3, 3, 3, 4, 1, 1, 5, 1, 3, 2, 4, 1, 5, 5, 1, 4, 4, 1, 4, 4, 1, 1, 2]
      school.develop 256
      expect(school.count).to eq(1681503251694)
    end

  end

  describe '#count' do
    it "counts 0 fish" do
      expect(School.new([]).count).to eq(0)
    end

    it "counts some fish" do
      expect(School.new([1, 2, 2]).count).to eq(3)
    end

  end

end
