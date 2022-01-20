require 'matrix'

class Day03
  def gamma_rate(points)
    to_i most_common to_bits points
  end

  def epsilon_rate(points)
    to_i least_common to_bits points
  end

  def oxygen_generator_rating(points)
    rating(points) { |bitses| most_common bitses}
  end

  def co2_scrubber_rating(points)
    rating(points) { |bitses| least_common bitses}
  end

  # TODO for efficiency, replace use of most_common/least_common with methods that only inspect the bit of interest
  private def rating(points)
    bitses = to_bits points
    position = 0
    while bitses.length > 1
      bits_to_select_by = yield bitses
      bitses = bitses.select { |bits| bits[position] == bits_to_select_by[position] }
      position += 1
    end
    to_i bitses.first
  end

  def to_bits(points)
    points.map { |point| point.rstrip.split('').map { |char| Integer char } }
  end

  private def least_common(bitses)
    most_common(bitses).map { |bit| 1 - bit }
  end

  private def most_common(bitses)
    frequencies(bitses).map { |freq| freq.to_f / bitses.length >= 0.5 ? 1 : 0 }
  end

  def frequencies(bitses)
    bitses
      .reduce(Vector.zero bitses.first.length) { |frequencies, bits| frequencies + Vector[*bits] }
      .to_a
  end

  private def to_i(bits)
    bits.map(&:to_s).join.to_i 2
  end

end
