class Polymerizer
  def initialize(rules)
    @rules = rules.map { |rule| rule.match(/([A-Z][A-Z]) -> ([A-Z])/).captures }.to_h
  end

  def polymerize(template, steps = 1)
    steps.times.reduce(template) do |product|
      (product.length - 1).times.map do |i|
        new_monomer = @rules[product[i, 2]]
        new_monomer ? "#{product[i]}#{new_monomer}" : product[i]
      end.join + product[product.length - 1]
    end
  end

  def signature(template, steps = 0)
    dimer_counts = (template.length - 1).times.map { |i| template[i, 2] }.tally
    dimer_counts = steps.times.reduce(dimer_counts) { |dcs| polymerize_once dcs }
    monomer_counts = monomer_counts dimer_counts, template
    monomer_counts.max - monomer_counts.min
  end

  private

  def polymerize_once(dimer_counts)
    new_counts =
      dimer_counts.each_pair.
      flat_map do |dimer, count|
        new_monomer = @rules[dimer]
        if new_monomer
          [[dimer[0] + new_monomer, count], [new_monomer + dimer[1], count]]
        else
          [[dimer, count]]
        end
      end
    merged new_counts
  end

  def monomer_counts(dimer_counts, template)
    monomer_counts = dimer_counts.each_pair.flat_map { |dimer, count| [[dimer[0], count], [dimer[1], count]] }
    monomer_counts = merged monomer_counts
    monomer_counts[template[0]] += 1
    monomer_counts[template[-1]] ||= 0
    monomer_counts[template[-1]] += 1
    monomer_counts.values.map { |count| count / 2 }
  end

  def merged(counts)
    counts.each_with_object({}) do |(dimer, count), new_counts|
      new_counts[dimer] ||= 0
      new_counts[dimer] += count
    end
  end

end
