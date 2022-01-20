class Parser
  def version_sum(packet)
    single_version_sum bits packet
  end

  private def single_version_sum(bits)
    version = int bits, 3
    packet_type_id = int bits, 3
    version +
      if packet_type_id == 4
        while bits.shift(5).first == 1; end
        0
      else
        length_type_id = int bits, 1
        if length_type_id == 0
          version_sum_by_bit_count bits
        else
          version_sum_by_packet_count bits
        end
      end
  end

  private def version_sum_by_bit_count(bits)
    bit_count = int bits, 15
    bits = bits.shift bit_count
    sum = 0
    while bits.any?
      sum += single_version_sum bits
    end
    sum
  end

  private def version_sum_by_packet_count(bits)
    packet_count = int bits, 11
    packet_count.times.map { single_version_sum bits }.sum
  end

  def result(packet)
    single_result bits packet
  end

  private def single_result(bits)
    discard_version bits
    packet_type_id = int bits, 3
    if packet_type_id == 4
      literal bits
    else
      length_type_id = int bits, 1
      results = length_type_id == 0 ? subpacket_results_by_bit_count(bits) : subpacket_results_by_packet_count(bits)
      case packet_type_id
        when 0
          results.sum
        when 1
          results.reduce 1, :*
        when 2
          results.min
        when 3
          results.max
        when 5
          results[0] > results[1] ? 1 : 0
        when 6
          results[0] < results[1] ? 1 : 0
        when 7
          results[0] == results[1] ? 1 : 0
      end
    end
  end

  private def literal(bits)
    value = 0
    while true
      continue = bits.shift
      value = 16 * value + int(bits, 4)
      if continue == 0
        return value
      end
    end
  end

  private def discard_version(bits)
    bits.shift 3
  end

  private def subpacket_results_by_bit_count(bits)
    bit_count = int bits, 15
    bits = bits.shift bit_count
    results = []
    while bits.any?
      results << single_result(bits)
    end
    results
  end

  private def subpacket_results_by_packet_count(bits)
    packet_count = int bits, 11
    packet_count.times.map { single_result bits }
  end

  private def bits(packet)
    bits = packet.to_i(16).to_s(2).chars.map(&:to_i)
    bits.unshift *Array.new(4 * packet.length - bits.length, 0)
    bits
  end

  private def int(bits, leading_bit_count)
    bits.shift(leading_bit_count).map(&:to_s).join.to_i 2
  end

end
