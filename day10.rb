# Part 1

require_relative 'helpers'
grid = File.readlines('data10.txt').map { |l| l.chomp.chars.map(&:to_i) }

reachable_9s = Array.new(grid.length) { Array.new(grid[0].length) { 0 } }

def mark_zeroes_reachable_from!(orig_i, orig_j, grid, reachable_9s)
  queue = [[orig_i, orig_j]]
  seen = Set.new([[orig_i, orig_j]])
  zeroes = Set.new

  until queue.empty?
    i, j = queue.pop
    reachable_9s[i][j] += 1
    zeroes << [i, j] if grid[i][j] == 0
    neighbors(i, j, grid).select { |i2, j2| grid[i2][j2] == grid[i][j] - 1 }.each { |coord| queue << coord }
  end
  zeroes.count
end

# Output how many 9s are reachable from a 0
sum = grid.each_with_index.sum do |row, i|
  row.each_with_index.sum do |n, j|
    next 0 unless n == 9
    mark_zeroes_reachable_from!(i, j, grid, reachable_9s)
  end
end

puts sum

# Part 2

# Output how many possible paths from a 9 to a 0
puts grid.flatten.zip(reachable_9s.flatten).select { |val, count| val == 0 }.sum(&:last)
