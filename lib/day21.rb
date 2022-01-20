class DeterministicGame
  attr_reader :scores, :current_player

  def initialize(player_positions)
    @die = DeterministicDie.new
    @player_positions = player_positions.map { |pp| pp - 1 }
    @current_player = 0
    @scores = [0, 0]
  end

  def play
    until scores.any? { |score| score >= 1000 }
      play_turn
    end
  end

  def play_turn
    spaces = 3.times.sum { @die.roll }
    @player_positions[@current_player] += spaces
    @player_positions[@current_player] %= 10
    @scores[@current_player] += @player_positions[@current_player] + 1
    @current_player += 1
    @current_player %= 2
  end

  def roll_count
    @die.roll_count
  end

end

class DeterministicDie
  attr_reader :roll_count

  def initialize
    @next_roll = 0
    @roll_count = 0
  end

  def roll
    @next_roll + 1
    @next_roll += 1
    @next_roll %= 100
    @roll_count += 1
  end

end

class Multiverse
  attr_reader :players, :wins

  def initialize(player_positions)
    @players = player_positions.map { |position| { Player.new(position, 0) => 1 } }
    @current_player_index = 0
    @wins = [0, 0]
  end

  def play
    until @players.all? &:empty?
      play_turn
    end
  end

  SPACES = (1..3).to_a.then { |roll| roll.product(roll, roll).map &:sum  }.tally

  def play_turn
    other_player_space_count = @players[1 - @current_player_index].values.sum
    @players[@current_player_index] =
      @players[@current_player_index].each_with_object({}) do |(player, player_count), new_players|
        SPACES.each do |spaces, space_count|
          new_player = player.after_moving spaces
          if new_player.score >= 21
            @wins[@current_player_index] += player_count * space_count * other_player_space_count
          else
            score = new_players[new_player]
            increment = player_count * space_count
            new_players[new_player] = score ? score + increment : increment
          end
        end
      end
    @current_player_index = 1 - @current_player_index
  end

end

class Player
  attr_reader :position, :score

  def initialize(position, score)
    @position = position - 1
    @score = score
  end

  def after_moving(spaces)
    new_position = (@position + spaces) % 10 + 1
    Player.new new_position, @score + new_position
  end

  def eql?(other)
    other.position == @position && other.score == @score
  end

  alias_method :==, :eql?

  def hash
    @position.hash ^ @score.hash
  end

end
