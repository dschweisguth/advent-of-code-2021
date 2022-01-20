class Day07
  def fuel_to_align(positions)
    positions.length.times.map do |position|
      positions.map { |a_position| (a_position - position).abs }.sum
    end.min
  end

  def fuel_to_align2(positions)
    positions.length.times.map do |position|
      positions.map do |a_position|
        distance = (a_position - position).abs
        distance * (distance + 1) / 2
      end.sum
    end.min
  end

end
