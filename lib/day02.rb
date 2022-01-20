Position = Struct.new :range, :depth do
  def ==(other)
    other.class == self.class && other.range == self.range && other.depth == self.depth
  end
end

Position2 = Struct.new :range, :depth, :aim do
  def ==(other)
    other.class == self.class && other.range == self.range && other.depth == self.depth && other.aim == self.aim
  end
end

class Day02
  def plot(movements)
    position = Position.new 0, 0
    movements.each do |movement|
      verb, amount = movement.split
      case verb
        when 'forward'
          position.range += Integer amount
        when 'down'
          position.depth += Integer amount
        when 'up'
          position.depth -= Integer amount
      end
    end
    position
  end

  def plot2(movements)
    position = Position2.new 0, 0, 0
    movements.each do |movement|
      verb, object = movement.split
      amount = Integer object
      case verb
        when 'forward'
          position.range += amount
          position.depth += amount * position.aim
        when 'down'
          # position.depth += amount
          position.aim += amount
        when 'up'
          # position.depth -= amount
          position.aim -= amount
      end
    end
    position
  end
end
