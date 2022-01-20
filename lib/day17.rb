class Day17
  def zenith(target)
    max_vy = hits(target).map { |_, vy| vy }.max
    max_vy * (max_vy + 1) / 2
  end

  def hit_count(target)
    hits(target).count
  end

  private

  def hits(target)
    possible_velocities(target).select { |velocity| hit? target, velocity }
  end

  def possible_velocities(target)
    (x1, y1), (x2, _) = target
    # At time vx, vx = 0 and x = vx (vx + 1) / 2, thus the lower bound
    min_vx = (Math.sqrt(2 * x1 + 0.25) - 0.5).floor
    (min_vx..x2).to_a.flat_map do |vx|
      # A probe that starts with positive vy will cross the x axis with vy + 1, thus the upper bound
      (y1..(-y1 - 1)).map { |vy| [vx, vy] }
    end
  end

  def hit?(((x1, y1), (x2, y2)), (vx, vy))
    x = 0
    y = 0
    while x <= x2 && y1 <= y
      if x1 <= x && y <= y2
        return true
      end
      x += vx
      y += vy
      if vx > 0
        vx -= 1
      end
      vy -= 1
    end
  end

end
