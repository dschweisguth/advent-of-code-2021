module Day04
  class Match
    attr_reader :winners

    def initialize(numberses, draws)
      @boards = numberses.map { |numbers| Board.new numbers }
      @draws = draws
      @winners = []
    end

    def play_to_first_win
      play { @winners.any? }
    end

    def play_to_last_win
      play { @boards.empty? }
    end

    private def play
      @draws.each do |number|
        @boards.each { |board| board.mark number }
        new_winners, @boards = @boards.partition &:winner?
        @winners += new_winners
        if yield
          break
        end
      end
    end

  end

  class Board
    def initialize(numberses)
      @spaces = numberses.map { |row| row.map { |number| Space.new number } }
    end

    def mark(number)
      @spaces.each do |row|
        row.each do |space|
          if number == space.number
            space.mark
            @last_number_marked = space.number
          end
        end
      end
    end

    def winner?
      any_row_is_marked || any_column_is_marked
    end

    private def any_row_is_marked
      @spaces.any? { |row| row.all? &:marked }
    end

    def any_column_is_marked
      @spaces.each_index.any? do |column|
        @spaces.all? { |row| row[column].marked }
      end
    end

    def numbers
      @spaces.map { |row| row.map &:number }
    end

    def score
      @spaces.flatten.reject(&:marked).map(&:number).sum * @last_number_marked
    end

  end

  class Space
    attr_reader :number, :marked

    def initialize(number)
      @number = number
      @marked = false
    end

    def mark
      @marked = true
    end

  end

end
