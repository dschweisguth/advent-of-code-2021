class Cave
  def initialize(risk)
    @risk = risk
    @x_size = @risk.first.length
    @y_size = @risk.length
  end

  def lowest_risk
    @unvisited_locations = PriorityQueue.new(
      @x_size.times.flat_map { |x| @y_size.times.map { |y| [[x, y], Float::INFINITY] } })
    @unvisited_locations.lower [0, 0], 0
    @distances = @y_size.times.map { Array.new @x_size, Float::INFINITY }
    @distances[0][0] = 0
    loop do
      x, y = @unvisited_locations.pop[0]
      if x == @x_size - 1 && y == @y_size - 1
        return @distances[y][x]
      end
      unvisited_neighbors(x, y).each do |nx, ny|
        distance_through_this_location = @distances[y][x] + @risk[ny][nx]
        if distance_through_this_location < @distances[ny][nx]
          @distances[ny][nx] = distance_through_this_location
          @unvisited_locations.lower [nx, ny], distance_through_this_location
        end
      end
    end
  end

  def unvisited_neighbors(x, y)
    neighbors = []
    if 0 < x && @unvisited_locations.include?([x - 1, y])
      neighbors << [x - 1, y]
    end
    if x < @x_size - 1 && @unvisited_locations.include?([x + 1, y])
      neighbors << [x + 1, y]
    end
    if 0 < y && @unvisited_locations.include?([x, y - 1])
      neighbors << [x, y - 1]
    end
    if y < @y_size - 1 && @unvisited_locations.include?([x, y + 1])
      neighbors << [x, y + 1]
    end
    neighbors
  end

end

class PriorityQueue
  def initialize(elements = [])
    @elements = [nil]
    @element_indexes = {}
    elements.each { |element| add *element }
  end

  def elements
    @elements[1, @elements.length]
  end

  def add(value, priority)
    @elements << [value, priority]
    index = @elements.length - 1
    @element_indexes[value] = index
    bubble_up index
  end

  def lower(value, priority)
    index = @element_indexes[value]
    @elements[index][1] = priority
    bubble_up index
  end

  private def bubble_up(index)
    if index == 1
      return
    end
    parent_index = index / 2
    if @elements[parent_index][1] <= @elements[index][1]
      return
    end
    swap index, parent_index
    bubble_up parent_index
  end

  def pop
    popped_element = @elements[1]
    @elements[1] = @elements.pop
    bubble_down 1
    @element_indexes.delete popped_element[0]
    popped_element
  end

  private def bubble_down(index)
    child_index = index * 2
    if child_index > @elements.size - 1
      return
    end
    if child_index < @elements.size - 1 && @elements[child_index + 1][1] < @elements[child_index][1]
      child_index += 1
    end
    if @elements[index][1] <= @elements[child_index][1]
      return
    end
    swap index, child_index
    bubble_down child_index
  end

  private def swap(index1, index2)
    @elements[index2], @elements[index1] = @elements[index1], @elements[index2]
    @element_indexes[@elements[index1][0]] = index1
    @element_indexes[@elements[index2][0]] = index2
  end

  def include?(value)
    @element_indexes.include? value
  end

end
