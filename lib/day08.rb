class Day08
  def easy_digit_count(entries)
    entries.map do |entry|
      entry.match(/(\S+) (\S+) (\S+) (\S+)$/).captures.select { |digit| [2, 3, 4, 7].include? digit.length }.count
    end.sum
  end

  def output_sum(entries)
    entries.map { |entry| output entry }.sum
  end

  private

  def output(entry)
    digits = entry.split /[^a-g]+/
    digits = digits.map { |digit| digit.chars.sort.join }
    signals = digits.shift 10

    values = { 'abcdefg' => 8 }

    c_f = signals.find { |signal| signal.length == 2 }
    values[c_f] = '1'

    values[signals.find { |signal| signal.length == 3 }] = '7'

    b_d_c_f = signals.find { |signal| signal.length == 4 }
    values[b_d_c_f] = '4'

    b_d = b_d_c_f.delete c_f

    values[signals.find { |signal| signal.length == 5 && !(contains_all(signal, b_d) || contains_all(signal, c_f)) }] = '2'
    values[signals.find { |signal| signal.length == 5 && contains_all(signal, c_f) }] = '3'
    values[signals.find { |signal| signal.length == 5 && contains_all(signal, b_d) }] = '5'

    values[signals.find { |signal| signal.length == 6 && !contains_all(signal, b_d) }] = '0'
    values[signals.find { |signal| signal.length == 6 && !contains_all(signal, c_f) }] = '6'
    values[signals.find { |signal| signal.length == 6 && contains_all(signal, b_d) && contains_all(signal, c_f) }] = '9'

    Integer digits.map { |digit| values[digit] }.join.sub(/^0*/, '')
  end

  def contains_all(string, chars)
    chars.chars.all? { |char| string.include? char }
  end

end
