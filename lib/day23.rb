# require 'stackprof'

class Burrow
  PODS = [0, 1, 2, 3]

  SPACES_2 = [
    [nil, nil,   0, nil,   2, nil,   4, nil,   6, nil, nil],
    [nil, nil,   1, nil,   3, nil,   5, nil,   7, nil, nil],
    [  8,   9,  10,  11,  12,  13,  14,  15,  16,  17,  18]
  ]

  SPACES_4 = [
    [nil, nil,   0, nil,   4, nil,   8, nil,  12, nil, nil],
    [nil, nil,   1, nil,   5, nil,   9, nil,  13, nil, nil],
    [nil, nil,   2, nil,   6, nil,  10, nil,  14, nil, nil],
    [nil, nil,   3, nil,   7, nil,  11, nil,  15, nil, nil],
    [ 16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26]
  ]

  XY_2 = [
    [2, 0], [2, 1], [4, 0], [4, 1], [6, 0], [6, 1], [8, 0], [8, 1],
    [0, 2], [1, 2], [2, 2], [3, 2], [4, 2], [5, 2], [6, 2], [7, 2], [8, 2], [9, 2], [10, 2]
  ]

  XY_4 = [
    [2, 0], [2, 1], [2, 2], [2, 3],
    [4, 0], [4, 1], [4, 2], [4, 3],
    [6, 0], [6, 1], [6, 2], [6, 3],
    [8, 0], [8, 1], [8, 2], [8, 3],
    [0, 4], [1, 4], [2, 4], [3, 4], [4, 4], [5, 4], [6, 4], [7, 4], [8, 4], [9, 4], [10, 4]
  ]

  attr_reader :room_space_count, :hall_spaces

  def initialize(room_space_count)
    @room_space_count = room_space_count
    @hall_spaces = [0, 1, 3, 5, 7, 9, 10].map { |space| space + first_hall_space }
    @first_room_spaces = (0..3).map { |pod| @room_space_count * pod }
    @first_and_last_room_spaces = @first_room_spaces.map { |first| [first, first + @room_space_count - 1] }
    @spaces, @xys =
      if @room_space_count == 2
        [SPACES_2, XY_2]
      else
        [SPACES_4, XY_4]
      end
  end

  def first_room_space(pod)
    @first_room_spaces[pod]
  end

  def first_and_last_room_spaces(pod)
    @first_and_last_room_spaces[pod]
  end

  def first_hall_space
    PODS.length * @room_space_count
  end

  def space(x, y)
    @spaces[y][x]
  end

  def xy(space)
    @xys[space]
  end

  def step_count(from, to)
    from_x, from_y = xy from
    to_x, to_y = xy to
    (to_x - from_x).abs + 2 * @room_space_count - to_y - from_y
  end

  BURROW_2 = Burrow.new 2
  BURROW_4 = Burrow.new 4

  def self.with(room_space_count)
    room_space_count == 2 ? BURROW_2 : BURROW_4
  end

end

class Formation
  def self.from(hash, room_space_count)
    formation = Formation.new Array.new Burrow::PODS.length * room_space_count + 11
    hash.reduce(formation) { |f, (xy, pod)| f.set xy, pod }
  end

  attr_reader :parent, :cost
  protected attr_reader :spaces

  def initialize(spaces, parent = nil, cost = 0)
    @burrow = Burrow.with(spaces.length == 19 ? 2 : 4)
    @spaces = spaces
    @parent = parent
    @cost = cost
  end

  def set(xy, pod)
    Formation.new spaces.dup.tap { |spaces| spaces[@burrow.space(*xy)] = pod }
  end

  def cost_to_organize
    _cost_to_organize
    # cost = nil
    # StackProf.run(mode: :cpu, out: 'stackprof.dump') { cost = _cost_to_organize }
    # cost
  end

  private def _cost_to_organize
    after_all_possible_moves.
      find { |formation| formation.organized? }.
      # tap(&:print_ancestry).
      cost
  end

  private def after_all_possible_moves
    formations = { self => self }
    new_formations = [self]
    while new_formations.any?
      new_formations.
        shift.
        after_possible_moves.
        each do |new_formation|
          remembered_formation = formations[new_formation]
          if !remembered_formation || new_formation.cost < remembered_formation.cost
            # The old and new keys are eql?, so this doesn't update the key, ...
            formations[new_formation] = new_formation
            new_formations << new_formation
          end
        end
    end
    formations.values #... so we return the values, not the keys
  end

  protected def after_possible_moves
    possible_moves.map do |from, to|
      new_spaces = spaces.dup
      pod = spaces[from]
      new_spaces[to] = pod
      new_spaces[from] = nil
      new_cost = cost + @burrow.step_count(from, to) * 10 ** pod
      Formation.new new_spaces, self, new_cost
    end
  end

  def possible_moves
    move_to_room || moves_to_hall
  end

  def move_to_room
    tos = available_room_spaces
    froms = room_spaces_with_pods_that_could_move_to_rooms.concat occupied_hall_spaces
    froms.each do |from|
      to = tos[@spaces[from]]
      if to && !path_blocked_in_hall?(from, to)
        return [[from, to]]
      end
    end
    nil
  end

  private def available_room_spaces
    Burrow::PODS.map do |pod|
      space, last_room_space = @burrow.first_and_last_room_spaces pod
      while space <= last_room_space
        occupant = @spaces[space]
        if !occupant
          break space
        elsif occupant != pod
          break nil
        end
        space += 1
      end
    end
  end

  private def room_spaces_with_pods_that_could_move_to_rooms
    Burrow::PODS.each_with_object([]) do |pod, froms|
      first_room_space, from = @burrow.first_and_last_room_spaces pod
      while from >= first_room_space
        occupant = @spaces[from]
        if occupant == pod
          break
        elsif occupant
          froms << from
          break
        end
        from -= 1
      end
    end
  end

  private def occupied_hall_spaces
    froms = []
    for from in @burrow.hall_spaces
      if @spaces[from]
        froms << from
      end
    end
    froms
  end

  def moves_to_hall
    unoccupied_hall_spaces = @burrow.hall_spaces.reject { |space| @spaces[space] }
    spaces_with_pods_that_could_move_to_hall.each_with_object([]) do |from, moves|
      unoccupied_hall_spaces.each do |to|
        if !path_blocked_in_hall? from, to
          moves << [from, to]
        end
      end
    end
  end

  private def spaces_with_pods_that_could_move_to_hall
    Burrow::PODS.each_with_object([]) do |pod, froms|
      first_room_space, from = @burrow.first_and_last_room_spaces pod
      while from >= first_room_space
        occupant = @spaces[from]
        if occupant && (occupant != pod || deeper_space_has_different_pod?(from, pod))
          froms << from
          break
        end
        from -= 1
      end
    end
  end

  private def deeper_space_has_different_pod?(space, pod)
    deeper_space = @burrow.first_room_space pod
    while deeper_space < space
      if has_different_pod? deeper_space, pod
        return true
      end
      deeper_space += 1
    end
    false
  end

  private def path_blocked_in_hall?(from, to)
    from_x, _ = @burrow.xy from
    to_x, _ = @burrow.xy to
    x, x2 = from_x < to_x ? [from_x + 1, to_x] : [to_x + 1, from_x]
    while x < x2
      if @spaces[@burrow.space(x, @burrow.room_space_count)]
        return true
      end
      x += 1
    end
  end

  protected def organized?
    Burrow::PODS.all? do |pod|
      first, last = @burrow.first_and_last_room_spaces pod
      (first..last).none? { |space| has_different_pod? space, pod }
    end &&
      @burrow.hall_spaces.none? { |space| @spaces[space] }
  end

  protected def print_ancestry
    ancestry = []
    child = self
    while child
      ancestry.unshift [child.cost - (child.parent&.cost || 0), child.cost, child]
      child = child.parent
    end
    ancestry.each do |move_cost, total_cost, formation|
      if total_cost == 0
        puts total_cost
      else
        puts "+ #{move_cost} = #{total_cost}"
      end
      formation.print
    end
  end

  protected def print
    puts @spaces[-11, 11].map { |occupant| occupant || '.' }.join
    (@burrow.room_space_count - 1).downto(0) do |space|
      puts "  #{Burrow::PODS.map { |pod| @spaces[@burrow.first_room_space(pod) + space] || '.' }.join(' ')}  "
    end
    puts
  end

  private def has_different_pod?(space, pod)
    occupant = @spaces[space]
    occupant && occupant != pod
  end

  def eql?(other)
    @spaces == other.spaces
  end

  alias_method :==, :eql?

  def hash
    @hash ||= @spaces.hash
  end

  def to_s
    "#{spaces_to_s @spaces} (#{if parent then "#{spaces_to_s parent.spaces} " end}#{cost})"
  end

  private def spaces_to_s(spaces)
    spaces.map { |space| space || '.' }.join
  end

end
