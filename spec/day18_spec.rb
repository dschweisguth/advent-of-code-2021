require_relative "../lib/day18.rb"

describe Day18 do
  let(:example_homework) do
    [
      [[[0, [5, 8]], [[1, 7], [9, 6]]], [[4, [1, 2]], [[1, 4], 2]]],
      [[[5, [2, 8]], 4], [5, [[9, 9], 0]]],
      [6, [[[6, 2], [5, 6]], [[7, 6], [4, 7]]]],
      [[[6, [0, 7]], [0, 9]], [4, [9, [9, 0]]]],
      [[[7, [6, 4]], [3, [1, 3]]], [[[5, 5], 1], 9]],
      [[6, [[7, 3], [3, 2]]], [[[3, 8], [5, 7]], 4]],
      [[[[5, 4], [7, 7]], 8], [[8, 3], 8]],
      [[9, 3], [[9, 9], [6, [4, 9]]]],
      [[2, [[7, 7], 7]], [[5, 8], [[9, 3], [0, 2]]]],
      [[[[5, 2], 5], [8, [3, 7]]], [[5, [7, 5]], [4, 4]]],
    ]
  end

  let(:puzzle_homework) do
    [
      [[[[7, 2], [0, 2]], 9], [[[7, 8], 6], [0, [2, 3]]]],
      [[[0, 9], 3], 1],
      [[[[0, 5], 6], [[0, 6], [7, 8]]], [[[2, 2], [1, 5]], [9, 5]]],
      [[2, 1], [[3, 1], [[3, 2], 9]]],
      [[[[9, 3], [7, 5]], [5, 9]], [[0, [0, 4]], 2]],
      [[[9, 9], 4], [8, [[4, 9], 7]]],
      [[[1, 9], [[8, 3], [6, 1]]], [5, 1]],
      [[[[8, 6], [1, 3]], [3, [1, 1]]], [[[6, 4], [0, 4]], [[0, 0], 3]]],
      [[[[6, 4], [3, 3]], [7, 5]], [[6, 5], [0, 4]]],
      [[[[6, 4], [2, 3]], 5], [9, [[4, 4], [7, 7]]]],
      [[1, [[7, 9], 1]], [[[8, 2], 5], [[7, 2], 8]]],
      [[[2, [7, 2]], [5, 3]], [1, 5]],
      [[[[2, 2], [1, 5]], [[1, 6], [0, 5]]], [6, [9, [9, 9]]]],
      [[7, 2], [[3, 8], [5, [6, 7]]]],
      [[[6, 5], [[8, 0], 1]], [2, [6, 0]]],
      [[[8, 7], 6], [[[7, 2], [7, 0]], 3]],
      [[[[9, 1], [0, 1]], [0, 4]], [8, 0]],
      [[[8, 2], [8, [2, 7]]], [[2, [2, 6]], [2, [1, 2]]]],
      [[[1, 7], [[0, 0], 3]], [[3, [3, 6]], [6, 3]]],
      [[[[5, 9], [1, 2]], [0, 0]], [[8, 8], 9]],
      [[[1, 2], [4, 2]], [3, 4]],
      [[[9, [0, 0]], [[3, 5], 7]], [[[8, 0], [2, 1]], [3, [1, 5]]]],
      [[[[9, 2], [7, 1]], [[0, 4], 5]], [9, 2]],
      [[3, [6, 1]], 2],
      [[[0, [0, 6]], [4, [5, 9]]], [[5, 9], 1]],
      [[[9, [8, 3]], 7], [[0, 7], [[8, 0], [9, 2]]]],
      [[[[0, 7], 7], [[1, 8], [4, 4]]], [[0, [6, 4]], [[4, 9], 4]]],
      [[[[3, 3], 3], 7], 4],
      [[4, [[5, 6], [8, 7]]], [[[7, 5], 2], [2, 4]]],
      [[[[3, 8], [3, 7]], 2], [[[4, 4], [9, 7]], 4]],
      [[[9, [2, 9]], 0], [7, [[3, 2], [3, 2]]]],
      [[[7, [6, 6]], [[6, 0], 1]], 9],
      [[3, 4], [[5, [9, 5]], [[2, 6], 2]]],
      [[[[7, 4], [6, 8]], [1, [8, 7]]], [[[2, 6], [1, 4]], [8, 7]]],
      [[3, [[0, 8], 3]], [[1, 8], 9]],
      [[3, [5, [0, 7]]], [[[2, 9], [9, 3]], [0, [8, 8]]]],
      [[[[1, 7], 5], [[4, 0], [7, 4]]], 8],
      [[[[3, 4], 3], 4], 0],
      [[[[1, 3], 7], [4, [8, 0]]], [[[5, 9], [4, 8]], [8, [7, 8]]]],
      [[[9, 1], [[7, 2], 7]], [[3, 0], 9]],
      [[[[6, 7], 2], 1], [[[1, 1], 6], [9, [3, 4]]]],
      [[[3, 8], [4, 0]], [[6, [1, 0]], [8, [8, 3]]]],
      [[[9, [4, 1]], 8], 2],
      [[[4, 3], [[7, 8], 5]], [[[0, 2], [0, 5]], [[1, 2], 2]]],
      [[2, 7], [[5, [8, 5]], [[3, 5], [9, 9]]]],
      [6, [[[2, 6], 1], [[2, 4], 9]]],
      [[[[8, 0], [1, 2]], [[1, 6], 0]], [[0, 4], [4, 6]]],
      [[[[7, 0], 6], [8, 1]], [6, 3]],
      [[[8, 4], [[7, 7], [2, 4]]], [[7, 8], [4, 5]]],
      [[[4, [5, 6]], [[3, 4], 0]], 4],
      [[0, 6], [[6, 1], [8, [9, 7]]]],
      [[4, [0, 6]], [5, [[3, 3], [8, 0]]]],
      [7, [[[8, 4], 4], [6, 7]]],
      [[[[7, 0], 5], [1, [4, 4]]], [[9, [0, 9]], [[5, 1], 9]]],
      [[[[4, 3], [9, 1]], 2], [0, [[8, 8], [1, 3]]]],
      [[[7, 0], [0, [2, 8]]], [[0, 5], [[2, 9], 5]]],
      [[[8, 8], [2, [0, 2]]], [[4, 5], 9]],
      [[3, 9], 5],
      [[[[8, 6], 3], [[5, 1], [0, 5]]], [3, 1]],
      [[[7, [1, 8]], [3, 4]], [4, [[7, 9], 5]]],
      [[[[4, 5], [4, 3]], [[6, 5], [6, 9]]], [[3, [7, 5]], [8, [2, 9]]]],
      [[5, 0], [[[2, 9], 1], [[0, 6], 6]]],
      [[4, [8, [3, 0]]], [[[9, 6], [1, 9]], [[1, 6], [8, 0]]]],
      [[[[8, 7], [5, 9]], [[2, 1], [3, 4]]], [5, 9]],
      [[[3, 3], [2, 8]], [[[1, 2], 9], [3, 2]]],
      [[[[0, 1], 5], [[0, 6], [9, 3]]], [5, [[5, 8], 5]]],
      [[[5, 6], [4, 5]], [[7, [2, 7]], [[3, 1], [0, 4]]]],
      [7, [[6, 2], [[7, 3], 6]]],
      [[[5, 3], [5, 7]], 6],
      [1, [[[6, 4], [8, 1]], [5, [7, 5]]]],
      [[[3, 6], [[7, 5], 7]], [[4, [4, 6]], [6, 4]]],
      [[[6, 3], 4], 5],
      [[[0, 9], [9, [0, 1]]], [0, [4, 9]]],
      [[[1, 0], 0], [[1, 4], [9, 6]]],
      [[[1, [8, 0]], [[9, 4], [2, 0]]], [4, [[6, 2], 3]]],
      [[[[6, 0], [5, 1]], 2], [[[9, 6], [5, 1]], 7]],
      [[[9, [3, 1]], [8, 1]], [[6, [0, 9]], [[7, 1], 4]]],
      [[[9, 2], [4, [5, 3]]], [[[7, 1], [2, 0]], [3, [2, 2]]]],
      [[[3, [7, 0]], 1], [6, [[9, 6], [4, 4]]]],
      [[2, 9], [6, [7, 3]]],
      [1, [[7, [1, 9]], 5]],
      [[[5, 3], [[1, 5], [7, 8]]], [[[5, 3], [6, 8]], [1, [5, 0]]]],
      [[[1, [7, 4]], [3, 8]], [1, [4, [6, 3]]]],
      [[[3, [8, 9]], 7], [[[3, 4], 3], [6, [3, 6]]]],
      [[[3, [1, 7]], [3, [1, 8]]], [[[6, 4], [6, 4]], [[8, 6], [3, 4]]]],
      [[4, 6], [[6, [8, 4]], 6]],
      [[[2, [7, 7]], [[1, 0], [6, 6]]], [[[8, 0], [1, 6]], [[0, 5], 9]]],
      [[[[3, 0], [2, 1]], [4, 7]], 3],
      [[[[1, 7], 2], [[8, 3], [8, 9]]], [[0, 4], [[6, 4], 2]]],
      [[[[3, 6], 9], [0, [6, 0]]], [7, 8]],
      [3, [[7, 8], 9]],
      [[1, [[7, 9], [1, 2]]], [2, 9]],
      [[[3, [3, 0]], 4], [[1, [5, 9]], [[9, 6], 5]]],
      [[1, [3, 4]], [[8, [2, 3]], 3]],
      [[[8, 0], 8], [[[1, 9], 3], [[0, 1], [8, 6]]]],
      [[[[4, 1], [3, 7]], [[6, 2], [5, 8]]], [[[4, 0], [2, 4]], [4, 7]]],
      [[[[9, 0], [5, 8]], 3], 2],
      [7, [[[1, 0], [9, 7]], [[8, 3], 0]]],
      [[[0, 1], [4, [4, 5]]], [9, [[3, 6], [6, 8]]]],
      [8, [[7, [4, 7]], [[0, 5], 3]]]
    ]
  end

  describe '#magnitude_of_sum' do
    it "returns the magnitude of the sum of a list of numbers" do
      numbers = [
        [1, [2, [3, [4, 5]]]],
        [6, 7]
      ]
      expect(subject.magnitude_of_sum numbers).to eq(487)
    end

    it "replicates the example homework" do
      expect(subject.magnitude_of_sum example_homework).to eq(4140)
    end

    it "solves the puzzle" do
      expect(subject.magnitude_of_sum puzzle_homework).to eq(4433)
    end

  end

  describe '#max_magnitude_of_sum_of_2' do
    it "returns the maximum magnitude of the sum of any two different numbers" do
      numbers = [
        [1, 2],
        [3, 4]
      ]
      expect(subject.max_magnitude_of_sum_of_2 numbers).to eq(65)
    end

    it "handles explosions" do
      numbers = [
        [[[[1, 2], 3], 4], [5, [6, [7, 8]]]],
        [[[[2, 3], 4], 5], [6, [7, [8, 9]]]]
      ]
      expect(subject.max_magnitude_of_sum_of_2 numbers).to eq(2518)
    end

    it "replicates the example homework" do
      expect(subject.max_magnitude_of_sum_of_2 example_homework).to eq(3993)
    end

    xit "solves the puzzle" do
      expect(subject.max_magnitude_of_sum_of_2 puzzle_homework).to eq(4559)
    end

  end

  describe '#magnitude' do
    it "returns a number's magnitude" do
      expect(subject.magnitude [1, 5]).to eq(13)
    end

    it "recurses" do
      expect(subject.magnitude [[1, 5], [7, 11]]).to eq(125)
    end

    [
      [[[1, 2], [[3, 4], 5]], 143],
      [[[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]], 1384],
      [[[[[1, 1], [2, 2]], [3, 3]], [4, 4]], 445],
      [[[[[3, 0], [5, 3]], [4, 4]], [5, 5]], 791],
      [[[[[5, 0], [7, 4]], [5, 5]], [6, 6]], 1137],
      [[[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]], 3488]
    ].each do |number, expected_magnitude|
      it "replicates the example #{number}" do
        expect(subject.magnitude number).to eq(expected_magnitude)
      end
    end

  end

  describe '#sum' do
    it "sums and reduces" do
      numbers = [
        [1, [2, [3, [4, 5]]]],
        [6, 7]
      ]
      expect(subject.sum numbers).to eq([[1, [2, [7, 0]]], [[5, 6], 7]])
    end

    it "sums repeatedly" do
      numbers = [
        [1, [2, [3, 4]]],
        [5, 6],
        [7, 8]
      ]
      expect(subject.sum numbers).to eq([[[1, [5, 0]], [9, 6]], [7, 8]])
    end

    it "replicates example 1" do
      numbers = [
        [[[[4, 3], 4], 4], [7, [[8, 4], 9]]],
        [1, 1]
      ]
      expect(subject.sum numbers).to eq([[[[0, 7], 4], [[7, 8], [6, 0]]], [8, 1]])
    end

    it "replicates example 2" do
      numbers = [
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4]
      ]
      expect(subject.sum numbers).to eq([[[[1,1],[2,2]],[3,3]],[4,4]])
    end

    it "replicates example 3" do
      numbers = [
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4],
        [5, 5]
      ]
      expect(subject.sum numbers).to eq([[[[3,0],[5,3]],[4,4]],[5,5]])
    end

    it "replicates example 4" do
      numbers = [
        [1, 1],
        [2, 2],
        [3, 3],
        [4, 4],
        [5, 5],
        [6, 6]
      ]
      expect(subject.sum numbers).to eq([[[[5, 0], [7, 4]], [5, 5]], [6, 6]])
    end

    it "replicates example 5" do
      numbers = [
        [[[0, [4, 5]], [0, 0]], [[[4, 5], [2, 6]], [9, 5]]],
        [7, [[[3, 7], [4, 3]], [[6, 3], [8, 8]]]],
        [[2, [[0, 8], [3, 4]]], [[[6, 7], 1], [7, [1, 6]]]],
        [[[[2, 4], 7], [6, [0, 5]]], [[[6, 8], [2, 8]], [[2, 1], [4, 5]]]],
        [7, [5, [[3, 8], [1, 4]]]],
        [[2, [2, 2]], [8, [8, 1]]],
        [2, 9],
        [1, [[[9, 3], 9], [[9, 0], [0, 7]]]],
        [[[5, [7, 4]], 7], 1],
        [[[[4, 2], 2], 6], [8, 7]]
      ]
      expect(subject.sum numbers).to eq([[[[8, 7], [7, 7]], [[8, 6], [7, 7]]], [[[0, 7], [6, 6]], [8, 7]]])
    end

    it "replicates the example homework" do
      expected_sum = [[[[6, 6], [7, 6]], [[7, 7], [7, 0]]], [[[7, 7], [7, 7]], [[7, 8], [9, 9]]]]
      expect(subject.sum example_homework).to eq(expected_sum)
    end

  end

  describe '#reduce' do
    it "explodes" do
      expect_reduce [1, [2, [3, [4, [5, 6]]]]], [1, [2, [3, [9, 0]]]]
    end

    it "splits" do
      expect_reduce [11, 1], [[5, 6], 1]
    end

    it "explodes repeatedly, then splits" do
      expect_reduce [1, [2, [3, [[4, 5], [6, 7]]]]], [1, [2, [[6, 6], [0, 6]]]]
    end

    def expect_reduce(unreduced_number, expected_number)
      subject.reduce unreduced_number
      expect(unreduced_number).to eq(expected_number)
    end

  end

  describe '#explode' do
    it "doesn't explode a three-deep number" do
      unreduced_number = [[[[1, 2], 3], 4], 5]
      exploded = subject.explode unreduced_number
      expect(exploded).to be_falsey
      expect(unreduced_number).to eq(unreduced_number)
    end

    it "explodes a four-deep number, adding to the left" do
      expect_explode [1, [2, [3, [4, [5, 6]]]]], [1, [2, [3, [9, 0]]]]
    end

    it "adds to the right" do
      expect_explode [[[[[1, 2], 3], 4], 5], 6], [[[[0, 5], 4], 5], 6]
    end

    it "adds to an immediate left and a distant right" do
      expect_explode [[1, [2, [3, [4, 5]]]], 6], [[1, [2, [7, 0]]], 11]
    end

    it "adds to a distant left and an immediate right" do
      expect_explode [1, [[[[2, 3], 4], 5], 6]], [3, [[[0, 7], 5], 6]]
    end

    it "adds to a nested left" do
      expect_explode [1, [2, [[3, 4], [[5, 6], 7]]]], [1, [2, [[3, 9], [0, 13]]]]
    end

    it "adds to a nested right" do
      expect_explode [1, [2, [[3, [4, 5]], [6, 7]]]], [1, [2, [[7, 0], [11, 7]]]]
    end

    it "adds to a doubly nested left" do
      expect_explode [1, [[2, [3, 4]], [[[5, 6], 7], 8]]], [1, [[2, [3, 9]], [[0, 13], 8]]]
    end

    it "adds to a doubly nested right" do
      expect_explode [1, [2, [[3, [4, 5]], [[6, 7], 8]]]], [1, [2, [[7, 0], [[11, 7], 8]]]]
    end

    it "explodes only once" do
      expect_explode [1, [2, [3, [[4, 5], [6, 7]]]]], [1, [2, [7, [0, [11, 7]]]]]
    end

    [
      [[[[[[9, 8], 1], 2], 3], 4], [[[[0, 9], 2], 3], 4]],
      [[7, [6, [5, [4, [3, 2]]]]], [7, [6, [5, [7, 0]]]]],
      [[[6, [5, [4, [3, 2]]]], 1], [[6, [5, [7, 0]]], 3]],
      [[[3, [2, [1, [7, 3]]]], [6, [5, [4, [3, 2]]]]], [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]]],
      [[[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]], [[3, [2, [8, 0]]], [9, [5, [7, 0]]]]]
    ].each do |unreduced_number, expected_number|
      it "replicates the example #{unreduced_number.inspect}" do
        expect_explode unreduced_number, expected_number
      end
    end

    def expect_explode(unreduced_number, expected_number)
      exploded = subject.explode unreduced_number
      expect(exploded).to be_truthy
      expect(unreduced_number).to eq(expected_number)
    end

  end

  describe '#split' do
    it "splits" do
      expect_split [11, 1], [[5, 6], 1]
    end

    it "splits only once" do
      expect_split [11, 11], [[5, 6], 11]
    end

    def expect_split unreduced_number, expected_number
      split = subject.split unreduced_number
      expect(split).to be_truthy
      expect(unreduced_number).to eq(expected_number)
    end

  end

end
