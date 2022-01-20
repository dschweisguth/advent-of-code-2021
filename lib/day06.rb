class School
  protected attr_reader :fish

  def initialize(fish)
    @fish = fish.tally
  end

  def develop(days)
    days.times do
      ready_to_reproduce_count = @fish.delete 0
      @fish =
        @fish.each_pair.map do |days_until_reproducing, n|
          [days_until_reproducing - 1, n]
        end.
        to_h
      if ready_to_reproduce_count
        @fish[6] ||= 0
        @fish[6] += ready_to_reproduce_count
        @fish[8] = ready_to_reproduce_count
      end
    end
  end

  def count
    @fish.values.sum
  end

  def ==(other)
    other.class == self.class && other.fish == fish
  end

end
