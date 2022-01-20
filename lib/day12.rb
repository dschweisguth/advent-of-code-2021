class System
  def initialize(connections)
    @connections = { 'end' => [] }
    connections.each do |connection|
      cave1, cave2 = connection.split '-'
      connect cave1, cave2
      connect cave2, cave1
    end
  end

  private def connect(cave1, cave2)
    if cave1 != 'end' && cave2 != 'start'
      @connections[cave1] ||= []
      @connections[cave1] << cave2
    end
  end

  def path_count(small_revisits_allowed = 0)
    incomplete_paths = [['start']]
    complete_paths = []
    until incomplete_paths.empty?
      incomplete_paths = incomplete_paths.flat_map do |path|
        @connections[path.last].
          reject { |cave| too_many_small_revisits path, cave, small_revisits_allowed }.
          each_with_object([]) do |cave, extensions|
            extension = path + [cave]
            if cave == 'end'
              complete_paths << extension
            else
              extensions << extension
            end
          end
      end
    end
    complete_paths.size
  end

  private def too_many_small_revisits(path, cave, small_revisits_allowed)
    if !small?(cave) || !path.include?(cave)
      return false
    end
    small_revisits = path.tally.select { |a_cave, visits| small?(a_cave) && visits > 1 }.size
    small_revisits_allowed - small_revisits < 1
  end

  private def small?(cave)
    cave.match? /^[a-z]+$/
  end

end
