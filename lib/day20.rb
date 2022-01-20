require 'matrix'

class MatrixEnhancer
  def initialize(algorithm)
    @algorithm = digits algorithm
  end

  private def digits(string)
    string.chars.map { |char| { '.' => 0, '#' => 1 }[char] }
  end

  def enhance(image, rounds)
    image _enhance matrix(image), rounds
  end

  def enhanced_pixel_count(image, rounds)
    _enhance(matrix(image), rounds).row_vectors.reduce(:+).sum
  end

  private

  def matrix(image)
    Matrix[*image.map(&method(:digits))]
  end

  def _enhance(starting_image, rounds)
    starting_image = add_1_pixel_margin starting_image, 0
    rounds.times.reduce(starting_image) do |image|
      image = add_1_pixel_margin image, image[0, 0]
      edge_digit = @algorithm[image[0, 0] == 0 ? 0 : 511]
      image = image.
        minor(1, image.row_count - 2, 1, image.column_count - 2).
        map.with_index { |_, i| new_digit image, *(i.divmod image.row_count - 2) }
      add_1_pixel_margin image, edge_digit
    end
  end

  # This runs twice as fast as iterating over image.minor
  def new_digit(image, row, col)
    index = 0
    (row..(row + 2)).each do |nrow|
      (col..(col + 2)).each do |ncol|
        index = (index << 1) + image[nrow, ncol]
      end
    end
    @algorithm[index]
  end

  def add_1_pixel_margin(image, digit)
    image =
      Matrix.hstack(
        Matrix.column_vector(Array.new image.row_count, digit),
        image,
        Matrix.column_vector(Array.new image.row_count, digit)
      )
    Matrix.vstack(
      Matrix.row_vector(Array.new image.column_count, digit),
      image,
      Matrix.row_vector(Array.new image.column_count, digit)
    )
  end

  def image(matrix)
    matrix.to_a.map { |row| row.map { |e| { 0 => '.', 1 => '#' }[e] }.join }
  end

end

# Around 20% slower
class BitVectorEnhancer
  def initialize(algorithm)
    @algorithm = algorithm.reverse.tr('.#', '01').to_i(2) + 2 ** 512
  end

  def enhance(image, rounds)
    image _enhance matrix(image), rounds
  end

  def enhanced_pixel_count(image, rounds)
    _enhance(matrix(image), rounds).map { |row| row.to_s(2).count('1') - 1 }.sum
  end

  private

  def matrix(image)
    image.map { |row| row.reverse.tr('.#', '01').to_i(2) + 2 ** row.length }
  end

  def _enhance(starting_image, rounds)
    starting_image = add_1_pixel_margin starting_image, 0
    rounds.times.reduce(starting_image) do |image|
      new_edge_digit = @algorithm[image[0][0] == 0 ? 0 : 511]
      image = add_1_pixel_margin image, image[0][0]
      new_column_count = image.first.bit_length - 3
      image =
        (1..(image.length - 2)).map do |row_index|
          # The starting value of 1 is the fence
          new_column_count.downto(1).reduce(1) do |row, col_index|
            (row << 1) + new_digit(image, row_index, col_index)
          end
        end
      add_1_pixel_margin image, new_edge_digit
    end
  end

  def new_digit(image, row, col)
    index = 0
    ((row - 1)..(row + 1)).each do |nrow|
      ((col - 1)..(col + 1)).each do |ncol|
        index = (index << 1) + image[nrow][ncol]
      end
    end
    @algorithm[index]
  end

  def add_1_pixel_margin(image, digit)
    fence = 1 << image.first.bit_length - 1
    top_and_bottom_margin = (fence << 2) + (digit == 0 ? 0 : (fence << 2) - 1)
    [
      top_and_bottom_margin,
      *image.map do |row|
        (fence << 2) + ((row - fence) << 1) + (digit == 0 ? 0 : (fence << 1) + 1)
      end,
      top_and_bottom_margin
    ]
  end

  def image(matrix)
    matrix.map { |row| row.to_s(2).delete_prefix('1').reverse.tr '01', '.#' }
  end

end
