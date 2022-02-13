class Seafloor
  E = '>'
  S = 'v'
  EMPTY = '.'

  attr_reader :map

  def initialize(map)
    @map = map.map &:dup
    @x_size = @map.first.length
    @y_size = @map.length
  end

  def settle
    step_count = 1
    while step
      step_count += 1
    end
    step_count
  end

  def step
    move_e | move_s
  end

  private def move_e
    moved = false
    @map.each do |row|
      move_last = row[@x_size - 1] == E && row[0] == EMPTY
      x = 0
      while x < @x_size - 1
        if row[x] == E && row[x + 1] == EMPTY
          row[x] = EMPTY
          row[x + 1] = E
          x += 1
          moved = true
        end
        x += 1
      end
      if move_last
        row[@x_size - 1] = EMPTY
        row[0] = E
        moved = true
      end
    end
    moved
  end

  private def move_s
    moved = false
    @x_size.times do |x|
      move_last = @map[@y_size - 1][x] == S && @map[0][x] == EMPTY
      y = 0
      while y < @y_size - 1
        if @map[y][x] == S && @map[y + 1][x] == EMPTY
          @map[y][x] = EMPTY
          @map[y + 1][x] = S
          y += 1
          moved = true
        end
        y += 1
      end
      if move_last
        @map[@y_size - 1][x] = EMPTY
        @map[0][x] = S
        moved = true
      end
    end
    moved
  end

end
