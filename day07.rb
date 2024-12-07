# Part 1

input = File.readlines('data07.txt')
            .map(&:chomp)
            .map do |line|
              sum, seq = line.split(':')
              [sum.to_i, seq.split.map(&:to_i)]
            end

# What are we doing here—
#   - You recursively check every branch in this tree of possible continuations
#   - It's extremely unlikely you'll revisit two of the same thing

def has_combination?(target, sequence, symbols = [:+, :*])
  suffix_combination?(target, sequence.drop(1), sequence.first, symbols)
end

def suffix_combination?(target, suffix, current, symbols)
  return true if current == target
  return false if suffix.empty?

  symbols.any? do |sym|
    suffix_combination?(target, suffix.drop(1), current.send(sym, suffix.first), symbols)
  end
end

puts input.sum { |(sum, seq)| has_combination?(sum, seq) ? sum : 0 }
