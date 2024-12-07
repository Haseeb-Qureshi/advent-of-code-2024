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

def has_combination?(target, sequence)
  combinable?(target, sequence.drop(1), sequence.first)
end

def combinable?(target, suffix, current, symbols = [:+, :*])
  return current == target if suffix.empty?

  symbols.any? do |sym|
    combinable?(target, suffix.drop(1), current.send(sym, suffix.first), symbols)
  end
end

puts input.sum { |(sum, seq)| has_combination?(sum, seq) ? sum : 0 }

# Part 2

class Integer
  def append(n)
    (self.to_s + n.to_s).to_i
  end
end

def has_combination_with_append?(target, sequence)
  syms = [:+, :*, :append]
  combinable?(target, sequence.drop(1), sequence.first, syms) ||
    combinable?(target, sequence.drop(2), sequence[0].append(sequence[1]), syms)
end

puts input.sum { |(sum, seq)| has_combination_with_append?(sum, seq) ? sum : 0 }
