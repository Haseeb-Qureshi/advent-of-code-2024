# Part 1

lines = File.readlines('data05.txt').map(&:chomp)
predecessors = Hash.new { |h, k| h[k] = Set.new }

until lines.first == ''
  a, b = lines.shift.split('|').map(&:to_i)
  predecessors[b] << a
end

def valid?(line, predecessors)
  line.each_index.all? do |i|
    (i + 1...line.length).each do |j|
      return false if predecessors[line[i]].include?(line[j])
    end
  end
  true
end

orderings = lines.drop(1).map { |l| l.split(',').map(&:to_i) }

puts orderings.select { |l| valid?(l, predecessors) }
              .sum { |l| l[l.length / 2] }

# Part 2
