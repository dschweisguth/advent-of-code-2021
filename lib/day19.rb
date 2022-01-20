require 'matrix'

class Scanalyzer
  def initialize(scans)
    @scans = scans scans
  end

  def beacon_count
    scanner_positions_and_known_beacons[1].size
  end

  def max_interscanner_distance
    max_distance scanner_positions_and_known_beacons[0]
  end

  private

  def scans(scans)
    scans.
      map { |scan| scan.map { |beacon| Vector[*beacon] } }.
      map do |scan|
      scan.each_with_object({}) do |beacon1, scans_with_distances|
        scans_with_distances[beacon1] =
          scan.grep_v(beacon1).map { |beacon2| (beacon2 - beacon1).to_a.map { |e| e ** 2 }.sum }
      end
    end
  end

  def scanner_positions_and_known_beacons
    scanner_positions = [Vector[0, 0, 0]]
    known_beacons = @scans.delete_at 0
    might_find_match = true
    while @scans.any? && might_find_match
      might_find_match = false
      i = 0
      while i < @scans.length
        recognized_beacons = recognized_beacons known_beacons, @scans[i]
        if recognized_beacons.length >= 12
          might_find_match = true
          scanner_position, new_known_beacons = oriented @scans[i], recognized_beacons
          scanner_positions << scanner_position
          merge! known_beacons, new_known_beacons
          @scans.delete_at i
        else
          i += 1
        end
      end
    end
    [scanner_positions, known_beacons]
  end

  def recognized_beacons(known_beacons, scan)
    known_beacons.each_with_object({}) do |(known_beacon, known_beacon_distances), recognized_beacons|
      scan.each do |new_beacon, new_beacon_distances|
        if (known_beacon_distances & new_beacon_distances).length >= 11
          recognized_beacons[new_beacon] = known_beacon
        end
      end
    end
  end

  POSSIBLE_SCANNER_ROTATIONS = [
    [[1, 0, 0], [0, 1, 0], [0, 0, 1]],
    [[1, 0, 0], [0, 0, -1], [0, 1, 0]],
    [[1, 0, 0], [0, -1, 0], [0, 0, -1]],
    [[1, 0, 0], [0, 0, 1], [0, -1, 0]],
    [[-1, 0, 0], [0, 1, 0], [0, 0, -1]],
    [[-1, 0, 0], [0, 0, -1], [0, -1, 0]],
    [[-1, 0, 0], [0, -1, 0], [0, 0, 1]],
    [[-1, 0, 0], [0, 0, 1], [0, 1, 0]],
    [[0, 1, 0], [0, 0, 1], [1, 0, 0]],
    [[0, 1, 0], [-1, 0, 0], [0, 0, 1]],
    [[0, 1, 0], [0, 0, -1], [-1, 0, 0]],
    [[0, 1, 0], [1, 0, 0], [0, 0, -1]],
    [[0, -1, 0], [0, 0, -1], [1, 0, 0]],
    [[0, -1, 0], [1, 0, 0], [0, 0, 1]],
    [[0, -1, 0], [0, 0, 1], [-1, 0, 0]],
    [[0, -1, 0], [-1, 0, 0], [0, 0, -1]],
    [[0, 0, 1], [1, 0, 0], [0, 1, 0]],
    [[0, 0, 1], [0, -1, 0], [1, 0, 0]],
    [[0, 0, 1], [-1, 0, 0], [0, -1, 0]],
    [[0, 0, 1], [0, 1, 0], [-1, 0, 0]],
    [[0, 0, -1], [1, 0, 0], [0, -1, 0]],
    [[0, 0, -1], [0, -1, 0], [-1, 0, 0]],
    [[0, 0, -1], [-1, 0, 0], [0, 1, 0]],
    [[0, 0, -1], [0, 1, 0], [1, 0, 0]]
  ].map { |r| Matrix[*r] }

  # Given a beacon position in a scanner's frame 'new_beacon' =
  #   some rotation matrix r * (that beacon's position in the reference frame 'known_beacon' - the scanner's position in that frame 'scanner')
  # i.e. new_beacon = r * (known_beacon - scanner),
  # · scanner = known_beacon - r-1 * new_beacon
  # · known_beacon = r-1 * new_beacon + scanner
  def oriented(scans, recognized_beacons)
    scanner_rotation, scanner_position =
      POSSIBLE_SCANNER_ROTATIONS.each do |scanner_rotation|
        scanner_positions =
          recognized_beacons.map { |new_beacon, known_beacon| known_beacon - scanner_rotation * new_beacon }.uniq
        if scanner_positions.one?
          break scanner_rotation, scanner_positions.first
        end
      end
    new_known_beacons = scans.transform_keys { |new_beacon| scanner_rotation * new_beacon + scanner_position }
    [scanner_position, new_known_beacons]
  end

  def merge!(known_beacons, new_known_beacons)
    new_known_beacons.each do |beacon, distances|
      known_beacons[beacon] ||= []
      known_beacons[beacon] |= distances
    end
  end

  def max_distance(positions)
    positions.combination(2).map { |p1, p2| (p2 - p1).map(&:abs).sum }.max
  end

end
