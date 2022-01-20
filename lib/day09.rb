class Map
  def initialize(locations)
    @locations = locations
  end

  def low_point_risk_level_sum
    low_points.map { |x, y| z(x, y) + 1 }.sum
  end

  def low_points
    x_size.times.flat_map do |x|
      y_size.times.map do |y|
        [x, y]
      end
    end.
    select do |x, y|
      z = z x, y
      neighbors(x, y).map { |nx, ny| z nx, ny }.all? { |nz| nz > z }
    end
  end

  private def neighbors(x, y)
    if x == 0
      if y == 0
        [[x + 1, y], [x, y + 1]]
      elsif y == y_size - 1
        [[x, y - 1], [x + 1, y]]
      else
        [[x, y - 1], [x + 1, y], [x, y + 1]]
      end
    elsif x == x_size - 1
      if y == 0
        [[x - 1, y], [x, y + 1]]
      elsif y == y_size - 1
        [[x, y - 1], [x - 1, y]]
      else
        [[x, y - 1], [x - 1, y], [x, y + 1]]
      end
    else
      if y == 0
        [[x - 1, y], [x + 1, y], [x, y + 1]]
      elsif y == y_size - 1
        [[x, y - 1], [x - 1, y], [x + 1, y]]
      else
        [[x, y - 1], [x - 1, y], [x + 1, y], [x, y + 1]]
      end
    end
  end

  def largest_basins_product
    basins.map(&:length).sort { |a, b| b <=> a }.first(3).reduce(1, :*)
  end

  def basins
    locations =
      x_size.times.flat_map do |x|
        y_size.times.map do |y|
          [x, y]
        end
      end.
      select { |x, y| z(x, y) != 9 }
    basins = []
    while locations.any? do
      basin = []
      might_have_neighbors = [locations.shift]
      while true
        neighbors, locations = locations.partition { |location| might_have_neighbors.any? { |mhn| are_neighbors mhn, location } }
        basin += might_have_neighbors
        if neighbors.empty?
          break
        end
        might_have_neighbors = neighbors
      end
      basins << basin
    end
    basins
  end

  private

  def are_neighbors(l1, l2)
    (l1[0] - l2[0]).abs + (l1[1] - l2[1]).abs == 1
  end

  def x_size
    @locations.first.length
  end

  def y_size
    @locations.length
  end

  def z(x, y)
    @locations[y][x]
  end

end
