class Day05
  def intersection_count_without_diagonals(line_strings)
    intersection_count lines(line_strings).select &:horizontal_or_vertical?
  end

  def intersection_count_with_diagonals(line_strings)
    intersection_count lines line_strings
  end

  private

  def lines(line_strings)
    line_strings.map do |string|
      args =
        string.match(/^(\d+),(\d+) -> (\d+),(\d+)$/).captures.
        map { |capture| Integer(capture) }
      Line.new *args
    end
  end

  def intersection_count(lines)
    lines.
      each_with_object(Set.new).with_index do |(line1, intersections), i|
        lines.slice(i + 1, lines.length).each do |line2|
          intersections.merge(line1.points & line2.points)
        end
      end.
      size
  end

end

class Line
  private attr_reader :start, :finish

  def initialize(x1, y1, x2, y2)
    @start = Point.new x1, y1
    @finish = Point.new x2, y2
  end

  def horizontal_or_vertical?
    horizontal? || vertical?
  end

  def points
    @points ||=
      begin
        length = (horizontal? ? finish.x - start.x : finish.y - start.y).abs + 1
        x_dir = -1 * (start.x <=> finish.x)
        y_dir = -1 * (start.y <=> finish.y)
        length.times.map { |i| Point.new start.x + (x_dir * i), start.y + (y_dir * i) }
      end
  end

  private

  def horizontal?
    start.y == finish.y
  end

  def vertical?
    start.x == finish.x
  end

end

class Point
  attr_reader :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def ==(other)
    other.class == self.class && other.x == x && other.y == y
  end

  alias_method :eql?, :==

  def hash
    @hash ||= [x, y].hash
  end

end
