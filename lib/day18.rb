class Day18
  def magnitude_of_sum(numbers)
    magnitude sum numbers
  end

  def max_magnitude_of_sum_of_2(numbers)
    numbers.flat_map do |number1|
      numbers.grep_v(number1).map do |number2|
        magnitude_of_sum [deep_dup(number1), deep_dup(number2)]
      end
    end.
    max
  end

  private def deep_dup(object)
    Marshal.load Marshal.dump object
  end

  def magnitude(number)
    first, second = number.map { |part| array?(part) ? magnitude(part) : part }
    3 * first + 2 * second
  end

  def sum(numbers)
    numbers.reduce do |sum, number|
      [sum, number].tap { |new_sum| reduce new_sum }
    end
  end

  def reduce(number)
    while explode(number) || split(number)
    end
  end

  def explode(number, depth = 0, left_neighbor: nil, left_neighbor_index: nil, right_neighbor: nil, right_neighbor_index: nil)
    if int? number
      false
    elsif depth < 3
      explode_children number, depth, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index
    else
      explode_self number, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index
    end
  end

  private def explode_children(number, depth, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index)
    explode_child(0, number, depth, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index) ||
      explode_child(1, number, depth, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index)
  end

  private def explode_child(index, number, depth, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index)
    if int? number[index]
      return false
    end
    new_neighbor, new_neighbor_index =
      if int? number[index - 1]
        [number, index - 1]
      else
        [number[index - 1], index]
      end
    neighbors =
      if index == 0
        {
          left_neighbor: left_neighbor,
          left_neighbor_index: left_neighbor_index,
          right_neighbor: new_neighbor,
          right_neighbor_index: new_neighbor_index
        }
      else
        {
          left_neighbor: new_neighbor,
          left_neighbor_index: new_neighbor_index,
          right_neighbor: right_neighbor,
          right_neighbor_index: right_neighbor_index
        }
      end
    explode number[index], depth + 1, **neighbors
  end

  private def explode_self(number, left_neighbor, left_neighbor_index, right_neighbor, right_neighbor_index)
    if array? number[0]
      if left_neighbor
        add_to_neighbor left_neighbor, left_neighbor_index, number[0][0]
      end
      add_to_neighbor number, 1, number[0][1], index_in_nested_numbers: 0
      number[0] = 0
      true
    elsif array? number[1]
      number[0] += number[1][0]
      if right_neighbor
        add_to_neighbor right_neighbor, right_neighbor_index, number[1][1]
      end
      number[1] = 0
      true
    else
      false
    end
  end

  private def add_to_neighbor(number, index, addend, index_in_nested_numbers: index)
    if int? number[index]
      number[index] += addend
    else
      add_to_neighbor number[index], index_in_nested_numbers, addend
    end
  end

  def split(number)
    (0..1).find do |i|
      xxx = number[i]
      if int?(xxx)
        if number[i] >= 10
          half = number[i].to_f / 2
          number[i] = [half.floor, half.ceil]
          true
        else
          false
        end
      else
        split number[i]
      end
    end
  end

  private

  def array?(object)
    object.is_a? Array
  end

  def int?(object)
    object.is_a? Integer
  end

end
