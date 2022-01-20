class Paper
  attr_reader :coordinates

  def initialize(instructions)
    coordinates = []
    @folds = []
    instructions.each do |instruction|
      if instruction.empty?
        next
      elsif instruction.include? ','
        coordinates << instruction.split(',').map(&:to_i)
      else
        axis, coordinate = instruction.match(/fold along (.)=(\d+)/).captures
        @folds << [axis.to_sym, coordinate.to_i]
      end
    end
    x_size = coordinates.max_by { |x, _| x }[0] + 1
    y_size = coordinates.max_by { |_, y| y }[1] + 1
    @coordinates = y_size.times.map { Array.new(x_size, '.') }
    coordinates.each { |x, y| @coordinates[y][x] = '#' }
  end

  def fold
    @folds.each do |fold_axis, fold_coordinate|
      @coordinates = fold_axis == :x ? fold_left(fold_coordinate) : fold_up(fold_coordinate)
    end
  end

  private def fold_left(fold_coordinate)
    left = @coordinates.map { |row| row[0, fold_coordinate] }
    right = @coordinates.map { |row| row[fold_coordinate + 1, row.length] }.map &:reverse
    smaller, larger = [left, right].sort_by { |coordinates| coordinates.first.length }
    offset = larger.first.length - smaller.first.length
    smaller.each_with_index do |row, y|
      row.each_with_index do |value, i|
        if value == '#'
          larger[y][offset + i] = '#'
        end
      end
    end
    larger
  end

  private def fold_up(fold_coordinate)
    top = @coordinates[0, fold_coordinate]
    bottom = @coordinates[fold_coordinate + 1, @coordinates.length].reverse
    smaller, larger = [top, bottom].sort_by &:length
    offset = larger.length - smaller.length
    smaller.each_with_index do |row, i|
      row.each_with_index do |value, x|
        if value == '#'
          larger[offset + i][x] = '#'
        end
      end
    end
    larger
  end

  def mark_count
    @coordinates.sum { |row| row.count '#' }
  end

end
