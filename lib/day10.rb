class Day10
  CORRUPTION_SCORE = {
    ')' => 3,
    ']' => 57,
    '}' => 1197,
    '>' => 25137
  }

  def corruption_score(lines)
    lines.map { |line| CORRUPTION_SCORE[problems(line)] || 0 }.sum
  end

  INCOMPLETENESS_SCORE = {
    '(' => 1,
    '[' => 2,
    '{' => 3,
    '<' => 4
  }

  def incompleteness_score(lines)
    line_scores =
      lines.
      map { |line| problems line }.
      select { |problems| problems.is_a? Array }.
      map do |problems|
        problems.reverse.reduce(0) { |score, problem| 5 * score + INCOMPLETENESS_SCORE[problem] }
      end
    line_scores.any? ? line_scores.sort[line_scores.length / 2] : 0
  end

  OPENING_CHAR = {
    ')' => '(',
    ']' => '[',
    '}' => '{',
    '>' => '<'
  }

  def problems(line)
    line.chars.each_with_object([]) do |char, stack|
      if %w|( [ { <|.include? char
        stack.push char
      elsif stack.last == OPENING_CHAR[char]
        stack.pop
      else
        return char
      end
    end
  end

end
