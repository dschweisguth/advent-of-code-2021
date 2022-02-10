class LiteralALU
  INSTRUCTIONS_PER_ITERATION = 18

  VARYING_INSTRUCTIONS = {
    4 => 'div z',
    5 => 'add x',
    15 => 'add y'
  }

  def initialize(program)
    iterations = program.each_slice(INSTRUCTIONS_PER_ITERATION).to_a
    raise_if_unexpected_lines_differ iterations
    @arguments = iterations.map do |iteration|
      VARYING_INSTRUCTIONS.map { |i, expected_op_and_var| argument iteration[i], expected_op_and_var }
    end
  end

  private def raise_if_unexpected_lines_differ(iterations)
    INSTRUCTIONS_PER_ITERATION.times.reject { |i| VARYING_INSTRUCTIONS.keys.include? i }.each do |i|
      iterations.each_with_index do |section, section_index|
        if section[i] != iterations.first[i]
          raise "Section 0 position #{i} has '#{iterations.first[i]}', but section #{section_index} has '#{section[i]}'"
        end
      end
    end
  end

  private def argument(instruction, expected_op_and_var)
    instruction.match(/^#{expected_op_and_var} (-?\d+)$/).captures.first.to_i
  end

  def valid_number(&block)
    @arguments.reduce({ 0 => 0 }) do |numbers, arguments|
      numbers.each_with_object({}) do |(z, number), new_numbers|
        (1..9).each do |digit|
          add_extended new_numbers, number, z, digit, arguments, &block
        end
      end
    end[0]
  end

  private def add_extended(new_numbers, number, z, digit, arguments)
    new_number = number * 10 + digit
    new_z = z z, digit, arguments
    number_for_z = new_numbers[new_z]
    if !number_for_z || yield(new_number, number_for_z)
      new_numbers[new_z] = new_number
    end
  end

  # inp w #0
  # mul x 0
  # add x z
  # mod x 26
  # div z #1
  # add x #2
  # eql x w
  # eql x 0
  # mul y 0
  # add y 25
  # mul y x
  # add y 1
  # mul z y
  # mul y 0
  # add y w
  # add y #3
  # mul y x
  # add z y
  private def z(z, digit, arguments)
    x, y = [0, 0]
    w = digit
    x *= 0
    x += z
    x %= 26
    z /= arguments[0]
    x += arguments[1]
    x = (x == w ? 1 : 0)
    x = (x == 0 ? 1 : 0)
    y *= 0
    y += 25
    y *= x
    y += 1
    z *= y
    y *= 0
    y += w
    y += arguments[2]
    y *= x
    z + y
  end

end

class SuccinctALU < LiteralALU
  # This version of MONAD shows that z is a base 26 number used as a stack.
  # When the first arg is 1 MONAD appends a digit (the model # digit + arg 2).
  # Otherwise, if the last digit == the model # digit - arg 1, it removes that digit.
  # Therefore,
  # - We can solve the puzzle without code by constructing the highest and lowest numbers
  #   which satisfy the relationships between digits.
  # - For MONAD to return 0, each digit appended to z must be removed,
  #   so we know the number is invalid the first time the arg 1 test fails.
  #
  # Iteration   Arguments       z, base 26    Constraints on digits        Solution 1 & 2
  # -------------------------------------------------------------------------------------
  #         0   [1, 12, 7]      z0            z0 = d0 + 7                           9   5
  #         1   [1, 12, 8]      z0z1          z1 = d1 + 8                           7   1
  #         2   [1, 13, 2]      z0z1z2        z2 = d2 + 2                           9   6
  #         3   [1, 12, 11]     z0z1z3z3      z3 = d3 + 11                          1   1
  #         4   [26, -3, 6]     z0z1z2        d4 + 3 = d3 + 11       d4 = d3 + 8    9   9
  #         5   [1, 10, 12]     z0z1z2z5      z5 = d5 + 12                          9   1
  #         6   [1, 14, 14]     z0z1z2z5z6    z6 = d6 + 14                          9   3
  #         7   [26, -16, 13]   z0z1z2z5      d7 + 16 = d6 + 14      d7 = d6 - 2    7   1
  #         8   [1, 12, 15]     z0z1z2z5z8    z8 = d8 + 15                          2   1
  #         9   [26, -8, 10]    z0z1z2z5      d9 + 8 = d8 + 15       d9 = d8 + 7    9   8
  #        10   [26, -12, 6]    z0z1z2        d10 + 12 = d5 + 12    d10 = d5        9   1
  #        11   [26, -7, 10]    z0z1          d11 + 7 = d2 + 2      d11 = d2 - 5    4   1
  #        12   [26, -6, 8]     z0            d12 + 6 = d1 + 8      d12 = d1 + 2    9   3
  #        13   [26, -11, 5]    0             d13 + 11 = d0 + 7     d13 = d0 - 4    5   1
  private def z(z, digit, arguments)
    if arguments[0] == 1
      26 * z + digit + arguments[2] # append a base-26 digit to z
    else
      z_least_significant_digit = z % 26
      if z_least_significant_digit == digit - arguments[1]
        z / 26
      else
        z - z_least_significant_digit + digit + arguments[2] # If we get here we know the number is invalid
      end
    end
  end
end

class OptimizedALU < LiteralALU
  private def add_extended(numbers, number, z, digit, arguments)
    new_number = number * 10 + digit
    new_z =
      if arguments[0] == 1
        26 * z + digit + arguments[2] # append a base-26 digit to z
      else
        if z % 26 == digit - arguments[1]
          z / 26
        else
          return
        end
      end
    number_for_z = numbers[new_z]
    if !number_for_z || yield(new_number, number_for_z)
      numbers[new_z] = new_number
    end
  end
end
