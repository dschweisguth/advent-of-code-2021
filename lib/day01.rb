class Day01
  def increases(values, window:)
    (1..(values.length - window)).to_a.count do |i|
      values[i, window].sum > values[i - 1, window].sum
    end
  end
end
