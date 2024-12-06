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

invalids = orderings.reject { |l| valid?(l, predecessors) }

def iterative_repair!(line, predecessors)
  swap_first_error!(line, predecessors) while !valid?(line, predecessors)
end

def swap_first_error!(line, predecessors)
  line.each_index do |i|
    (i + 1...line.length).each do |j|
      if predecessors[line[i]].include?(line[j])
        line[i], line[j] = line[j], line[i]
        return
      end
    end
  end
end

invalids.each { |l| iterative_repair!(l, predecessors) }
puts invalids.sum { |l| l[l.length / 2] }
