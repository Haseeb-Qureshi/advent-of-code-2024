# Part 1

# Either all increasing or all decreasing
# Adjacent levels must differ by 1-3

input = File.readlines("data02.txt").map { |line| line.chomp.split.map(&:to_i) }

def safe?(line)
  direction = line.first(2).yield_self { |a, b| a <=> b }
  line.each_cons(2).all? { |a, b| follows_rule?(direction, a, b) }
end

def follows_rule?(direction, a, b)
  (a <=> b) == direction && (a - b).abs.between?(1, 3)
end

puts input.count { |line| safe?(line) }

# Part 2

def safe_with_removal?(line)
  permutations = line.size.times.map { |i| line.dup.tap { |l| l.delete_at(i) } }
  safe?(line) || permutations.any? { |l| safe?(l) }
end

puts input.count { |line| safe_with_removal?(line) }
