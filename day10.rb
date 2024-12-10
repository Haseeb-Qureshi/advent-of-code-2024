# Part 1

require_relative 'helpers'
grid = File.readlines('data10.txt').map { |l| l.chomp.chars.map(&:to_i) }

# Find each 9 and follow every path from there that climbs up
can_reach_nines = Array.new(grid.length) { Array.new(grid[0].length) { 0 } }

def neighbors(i, j, grid)
  [
    [i + 1, j],
    [i - 1, j],
    [i, j + 1],
    [i, j - 1],
  ].select { |x, y| in_grid?(grid, x, y) }
end

def mark_trails_reachable_from!(orig_i, orig_j, grid, can_reach_nines)
  queue = [[orig_i, orig_j]]
  seen = Set.new([[orig_i, orig_j]])

  until queue.empty?
    i, j = queue.pop



  end
end

def nines_reachable_from(orig_i, orig_j, grid)
  queue = [[orig_i, orig_j]]
  seen = Set.new([[orig_i, orig_j]])
  nines = Set.new

  until queue.empty?
    i, j = queue.pop
    nines << [i, j] if grid[i][j] == 9
    neighbors(i, j, grid).select { |i2, j2| grid[i2][j2] == grid[i][j] + 1 }.each { |coord| queue << coord }
  end
  nines.count
end

sum = grid.each_with_index.sum do |row, i|
  row.each_with_index.sum do |n, j|
    next 0 unless n == 0
    # mark_trails_from!(i, j, grid, can_reach_nines)
    nines_reachable_from(i, j, grid)
  end
end

puts sum
