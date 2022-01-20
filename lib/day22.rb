require 'set'

module RangeUtilities
  private def ranges_intersect?(range1, range2)
    !(range1[1] < range2[0] || range2[1] < range1[0])
  end
end

class Reactor
  include RangeUtilities

  def initialize
    @cuboids = Set[]
  end

  def initialize_reactor(lines)
    execute select_initialization instructions lines
  end

  private def select_initialization(instructions)
    instructions.reject do |_, cuboid|
      cuboid.ranges.any? { |range| !ranges_intersect? range, [-50, 50] }
    end
  end

  def reboot(lines)
    execute instructions lines
  end

  private def instructions(lines)
    lines.map do |line|
      on_or_off, *range_strings =
        line.match(/^(on|off) x=(-?\d+..-?\d+),y=(-?\d+..-?\d+),z=(-?\d+..-?\d+)/).captures
      # Using arrays instead of ranges is about 10% faster and no less clear.
      # The version of this program that used ranges didn't use any range methods other than .begin and .end.
      # Also, Stackprof overcounts time spent in .begin and .end.
      ranges = range_strings.map { |s| eval(s).then { |range| [range.begin, range.end] } }
      [on_or_off, Cuboid.new(ranges)]
    end
  end

  private def execute(instructions)
    instructions.each do |on_or_off, incoming_cuboid|
      if on_or_off == 'on'
        add incoming_cuboid
      else
        subtract incoming_cuboid
      end
    end
  end

  private def add(initial_incoming_cuboid)
    incoming_cuboids = [initial_incoming_cuboid]
    while incoming_cuboids.any?
      incoming_cuboid = incoming_cuboids.shift
      intersecting_cuboid = intersecting_cuboid incoming_cuboid
      if intersecting_cuboid
        incoming_cuboids += incoming_cuboid.sections_not_in intersecting_cuboid
      else
        @cuboids << incoming_cuboid
      end
    end
  end

  private def subtract(incoming_cuboid)
    new_cuboids = []
    while true
      intersecting_cuboid = intersecting_cuboid incoming_cuboid
      if !intersecting_cuboid
        break
      end
      @cuboids.delete intersecting_cuboid
      new_cuboids += intersecting_cuboid.sections_not_in incoming_cuboid
    end
    @cuboids += new_cuboids
  end

  private def intersecting_cuboid(incoming_cuboid)
    @cuboids.find { |cuboid| cuboid.intersect? incoming_cuboid }
  end

  def cube_count
    @cuboids.map(&:cube_count).sum
  end

end

class Cuboid
  include RangeUtilities

  attr_reader :ranges

  def initialize(ranges)
    if ranges.any? { |range| range[0] > range[1] }
      raise "One or more ranges is backwards: #{ranges}"
    end
    @ranges = ranges
  end

  def intersect?(other)
    # [0, 1, 2] is 3 times as fast as 3.times!
    [0, 1, 2].none? { |axis| !ranges_intersect? ranges[axis], other.ranges[axis] }
  end

  def sections_not_in(other)
    ranges = self.ranges.dup
    sections = []
    covered = false
    until covered
      covered = true
      3.times.each do |axis|
        range = ranges[axis]
        other_range = other.ranges[axis]
        intersecting_and_nonintersecting_ranges =
          if range[0] < other_range[0]
            [[other_range[0], range[1]], [range[0], (other_range[0] - 1)]]
          elsif other_range[1] < range[1]
            [[range[0], other_range[1]], [(other_range[1] + 1), range[1]]]
          end
        if intersecting_and_nonintersecting_ranges
          sections << Cuboid.new(ranges.dup.tap { |r| r[axis] = intersecting_and_nonintersecting_ranges[1] })
          ranges[axis] = intersecting_and_nonintersecting_ranges[0]
          covered = false
          break
        end
      end
    end
    sections
  end

  def cube_count
    @ranges.map { |range| range[1] - range[0] + 1 }.reduce :*
  end

  def eql?(other)
    other.class == self.class && other.ranges == ranges
  end

  alias_method :==, :eql?

  def hash
    @hash ||= ranges.hash
  end

  def to_s
    ranges.inspect
  end

end
