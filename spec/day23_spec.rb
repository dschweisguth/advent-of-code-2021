require_relative "../lib/day23.rb"

A = 0
B = 1
C = 2
D = 3

context "rooms have 2 spaces" do
  let(:room_space_count) { 2 }

  describe Formation do
    describe '#cost_to_organize' do
      it "moves a pod to its rooms" do
        expect_cost_to_organize({ [1, 2] => A }, 3)
      end

      [
        [{ [3, 2] => B }, 30],
        [{ [5, 2] => C }, 300],
        [{ [7, 2] => D }, 3000]
      ].each do |starting_formation, expected_cost|
        it "moves a type #{starting_formation.first[1]} pod to its rooms" do
          expect_cost_to_organize starting_formation, expected_cost
        end
      end

      it "moves all pods to their rooms" do
        expect_cost_to_organize({ [1, 2] => A, [3, 2] => B }, 33)
      end

      it "returns the lowest cost to move all pods to their rooms" do
        # This returns the cost of moving A out of the way, moving B home and then moving A home,
        # which is cheaper than moving B out of the way first.
        expect_cost_to_organize({ [2, 0] => B, [4, 0] => A }, 68)
      end

      it "replicates the example" do
        starting_formation = {
          [2, 0] => A, [2, 1] => B,
          [4, 0] => D, [4, 1] => C,
          [6, 0] => C, [6, 1] => B,
          [8, 0] => A, [8, 1] => D
        }
        expect_cost_to_organize starting_formation, 12521
      end

      xit "solves the puzzle" do
        starting_formation = {
          [2, 0] => B, [2, 1] => C,
          [4, 0] => A, [4, 1] => D,
          [6, 0] => B, [6, 1] => D,
          [8, 0] => C, [8, 1] => A
        }
        expect_cost_to_organize starting_formation, 12530
      end

    end

    describe '#possible_moves' do
      it "moves a single pod to its room if possible" do
        expect_possible_moves({ [4, 0] => A }, [[2, 0]])
      end

      it "returns all possible moves to the hall if there are no moves to a room" do
        expected_moves = [
          [0, 8], [0, 9], [0, 11], [0, 13], [0, 15], [0, 17], [0, 18],
          [2, 8], [2, 9], [2, 11], [2, 13], [2, 15], [2, 17], [2, 18]
        ]
        expect(possible_moves({ [2, 0] => B, [4, 0] => A })).to eq(expected_moves)
      end

    end

    describe '#move_to_room' do
      it "moves a pod to its inner space" do
        expect_move_to_room({ [1, 2] => A }, [9, 0])
      end

      [
        [{ [3, 2] => B }, [11, 2]],
        [{ [5, 2] => C }, [13, 4]],
        [{ [7, 2] => D }, [15, 6]]
      ].each do |formation, expected_moves|
        it "moves a type #{formation.values.first} pod to its inner space" do
          expect_move_to_room formation, expected_moves
        end
      end

      it "moves a pod out of a wrong room" do
        expect_move_to_room({ [4, 0] => A }, [2, 0])
      end

      it "moves a pod to its outer space if its inner space is occupied" do
        expect_move_to_room({ [1, 2] => A, [2, 0] => A }, [9, 1])
      end

      it "doesn't move a pod to its outer space if its inner space is occupied by a different pod" do
        expect_move_to_room({ [2, 0] => B, [4, 0] => C }, [2, 4])
      end

      it "doesn't move a pod in a wrong inner space through a pod in that outer space" do
        expect_move_to_room({ [4, 0] => A, [4, 1] => A }, [3, 0])
      end

      it "doesn't move a pod through a pod in the hall" do
        expect_move_to_room({ [5, 2] => A, [3, 2] => A }, [11, 0])
      end

    end

    describe '#moves_to_hall' do
      it "returns all moves of a pod from a room to the hall" do
        expected_moves = [[0, 8], [0, 9], [0, 11], [0, 13], [0, 15], [0, 17], [0, 18]]
        expect_moves_to_hall({ [2, 0] => B }, expected_moves)
      end

      it "moves a pod from its room if it's blocking a different pod" do
        expected_moves = [0, 1, 3, 5, 7, 9, 10].map { |hall_space| [1, 8 + hall_space] }
        expect_moves_to_hall({ [2, 0] => B, [2, 1] => A }, expected_moves)
      end

      it "doesn't move a pod from its room if it's not blocking a different pod" do
        expect_moves_to_hall({ [2, 0] => A }, [])
      end

      it "doesn't move a pod from its room if it's blocking a pod of the same type" do
        expect_moves_to_hall({ [2, 0] => A, [2, 1] => A }, [])
      end

      it "doesn't move a pod to an occupied space" do
        expect(moves_to_hall({ [0, 2] => A, [2, 1] => B }).any? { |_, to| to == 8 }).to be_falsey
      end

      it "doesn't move a pod through a pod in the hall" do
        formation = { [1, 2] => A, [2, 0] => B, [4, 0] => A, [5, 2] => B }
        expect_moves_to_hall formation, [[0, 11], [2, 11]]
      end

    end

    describe '#to_s' do
      it "represents a formation with a parent" do
        parent = Formation.new Array.new(19).tap { |spaces| spaces[9] = 0 }
        child = Formation.new Array.new(19).tap { |spaces| spaces[0] = 0 }, parent, 3
        expect(child.to_s).to eq('0.................. (.........0......... 3)')
      end

      it "represents a formation without a parent" do
        child = Formation.new Array.new(19).tap { |spaces| spaces[0] = 0 }
        expect(child.to_s).to eq('0.................. (0)')
      end

    end

  end

  describe Burrow do
    describe '#step_count' do
      let(:burrow) { Burrow.new room_space_count }

      it "counts a move from a room to another room" do
        expect_step_count 0, 2, 6
      end

      it "counts a move from the hall to a room" do
        expect_step_count 9, 0, 3
      end

      it "counts a move from a room to the hall" do
        expect_step_count 0, 9, 3
      end

    end
  end

end

context "rooms have 4 spaces" do
  let(:room_space_count) { 4 }

  describe Formation do
    describe '#cost_to_organize' do
      it "moves a pod to its rooms" do
        expect_cost_to_organize({ [1, 4] => A }, 5)
      end

      [
        [{ [3, 4] => B }, 50],
        [{ [5, 4] => C }, 500],
        [{ [7, 4] => D }, 5000]
      ].each do |starting_formation, expected_cost|
        it "moves a type #{starting_formation.first[1]} pod to its rooms" do
          expect_cost_to_organize starting_formation, expected_cost
        end
      end

      it "moves all pods to their rooms" do
        expect_cost_to_organize({ [1, 4] => A, [3, 4] => B }, 55)
      end

      it "returns the lowest cost to move all pods to their rooms" do
        # This returns the cost of moving A out of the way, moving B home and then moving A home,
        # which is cheaper than moving B out of the way first.
        expect_cost_to_organize({ [2, 0] => B, [4, 0] => A }, 112)
      end

      xit "replicates the example" do
        starting_formation = {
          [2, 0] => A, [2, 1] => D, [2, 2] => D, [2, 3] => B,
          [4, 0] => D, [4, 1] => B, [4, 2] => C, [4, 3] => C,
          [6, 0] => C, [6, 1] => A, [6, 2] => B, [6, 3] => B,
          [8, 0] => A, [8, 1] => C, [8, 2] => A, [8, 3] => D
        }
        expect_cost_to_organize starting_formation, 44169
      end

      xit "solves the puzzle" do
        starting_formation = {
          [2, 0] => B, [2, 1] => D, [2, 2] => D, [2, 3] => C,
          [4, 0] => A, [4, 1] => B, [4, 2] => C, [4, 3] => D,
          [6, 0] => B, [6, 1] => A, [6, 2] => B, [6, 3] => D,
          [8, 0] => C, [8, 1] => C, [8, 2] => A, [8, 3] => A
        }
        expect_cost_to_organize starting_formation, 50492
      end

    end

    describe '#possible_moves' do
      it "moves a single pod to its room if possible" do
        expect_possible_moves({ [4, 0] => A }, [[4, 0]])
      end

      it "returns all possible moves to the hall if there are no moves to a room" do
        expected_moves = [
          [0, 16], [0, 17], [0, 19], [0, 21], [0, 23], [0, 25], [0, 26],
          [4, 16], [4, 17], [4, 19], [4, 21], [4, 23], [4, 25], [4, 26]
        ]
        expect(possible_moves({ [2, 0] => B, [4, 0] => A })).to eq(expected_moves)
      end

    end

    describe '#move_to_room' do
      it "moves a pod to its innermost space" do
        expect_move_to_room({ [1, 4] => A }, [17, 0])
      end

      [
        [{ [3, 4] => B }, [19, 4]],
        [{ [5, 4] => C }, [21, 8]],
        [{ [7, 4] => D }, [23, 12]]
      ].each do |formation, expected_moves|
        it "moves a type #{formation.values.first} pod to its innermost space" do
          expect_move_to_room formation, expected_moves
        end
      end

      it "moves a pod out of a wrong room" do
        expect_move_to_room({ [4, 0] => A }, [4, 0])
      end

      it "moves a pod to an outer space if an inner space is occupied" do
        expect_move_to_room({ [1, 4] => A, [2, 0] => A, [2, 1] => A, [2, 2] => A }, [17, 3])
      end

      it "doesn't move a pod to an outer space if an inner space is occupied by a different pod" do
        expect_move_to_room({ [2, 0] => B, [4, 0] => C }, [4, 8])
      end

      it "doesn't move a pod in a wrong inner space through a pod in that outer space" do
        expect_move_to_room({ [4, 0] => A, [4, 1] => A }, [5, 0])
      end

      it "doesn't move a pod through a pod in the hall" do
        expect_move_to_room({ [5, 4] => A, [3, 4] => A }, [19, 0])
      end

    end

    describe '#moves_to_hall' do
      it "returns all moves of a pod from a room to the hall" do
        expected_moves = [[0, 16], [0, 17], [0, 19], [0, 21], [0, 23], [0, 25], [0, 26]]
        expect_moves_to_hall({ [2, 0] => B }, expected_moves)
      end

      it "moves a pod from its room if it's blocking a different pod" do
        expected_moves = [0, 1, 3, 5, 7, 9, 10].map { |to_x| [1, to_x + 16] }
        expect_moves_to_hall({ [2, 0] => B, [2, 1] => A }, expected_moves)
      end

      it "doesn't move a pod from its room if it's not blocking a different pod" do
        expect_moves_to_hall({ [2, 0] => A }, [])
      end

      it "doesn't move a pod from its room if it's blocking a pod of the same type" do
        expect_moves_to_hall({ [2, 0] => A, [2, 1] => A, [2, 2] => A, [2, 3] => A }, [])
      end

      it "doesn't move a pod to an occupied space" do
        expect(moves_to_hall({ [0, 4] => A, [2, 1] => B }).any? { |_, to| to == 16 }).to be_falsey
      end

      it "doesn't move a pod through a pod in the hall" do
        formation = { [1, 4] => A, [2, 0] => B, [4, 0] => A, [5, 4] => B }
        expect_moves_to_hall formation, [[0, 19], [4, 19]]
      end

    end

  end

  describe Burrow do
    describe '#step_count' do
      let(:burrow) { Burrow.new room_space_count }

      it "counts a move from a room to another room" do
        expect_step_count 0, 4, 10
      end

      it "counts a move from the hall to a room" do
        expect_step_count 17, 0, 5
      end

      it "counts a move from a room to the hall" do
        expect_step_count 0, 17, 5
      end

    end
  end

end

def expect_cost_to_organize(starting_formation, expected_cost)
  expect(formation(starting_formation).cost_to_organize).to eq(expected_cost)
end

def expect_possible_moves(formation, expected_moves)
  expect(possible_moves formation).to eq(expected_moves)
end

def possible_moves(formation)
  formation(formation).possible_moves
end

def expect_move_to_room(formation, expected_move)
  expect(formation(formation).move_to_room).to eq([expected_move])
end

def expect_moves_to_hall(formation, expected_moves)
  expect(moves_to_hall formation).to eq(expected_moves)
end

def moves_to_hall(formation)
  formation(formation).moves_to_hall
end

def formation(formation)
  Formation.from(formation, room_space_count)
end

def expect_step_count(from, to, expected_count)
  expect(burrow.step_count from, to).to eq(expected_count)
end
