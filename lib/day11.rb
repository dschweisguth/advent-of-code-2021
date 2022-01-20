class Octopuses
  attr_reader :levels

  def initialize(levels)
    @levels = levels
  end

  def wait
    y_size.times { |y| x_size.times { |x| @levels[y][x] += 1 } }
    already_flashed = Set.new
    loop do
      ready_to_flash =
        y_size.times.flat_map { |y| x_size.times.map { |x| [x, y] } }.
        select { |x, y| @levels[y][x] > 9 && !already_flashed.include?([x, y]) }
      if ready_to_flash.empty?
        break
      end
      ready_to_flash.each do |x, y|
        neighbors(x, y).each do |nx, ny|
          @levels[ny][nx] += 1
        end
      end
      already_flashed += ready_to_flash
    end
    already_flashed.each { |x, y| @levels[y][x] = 0 }
    already_flashed.length
  end

  def neighbors(x, y)
    neighbors = []
    if 0 < y
      if 0 < x
        neighbors << [x - 1, y - 1]
      end
      neighbors << [x, y - 1]
      if x < x_size - 1
        neighbors << [x + 1, y - 1]
      end
    end
    if 0 < x
      neighbors << [x - 1, y]
    end
    if x < x_size - 1
      neighbors << [x + 1, y]
    end
    if y < y_size - 1
      if 0 < x
        neighbors << [x - 1, y + 1]
      end
      neighbors << [x, y + 1]
      if x < x_size - 1
        neighbors << [x + 1, y + 1]
      end
    end
    neighbors
  end

  def x_size
    @levels.first.length
  end

  def y_size
    @levels.length
  end

end
