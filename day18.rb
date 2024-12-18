# Part 1
require_relative 'helpers'

SAFE = '.'.freeze
CORRUPTED = '#'.freeze

GRID_SIZE = 70 + 1
FILE = File.readlines('data18.txt')
GRID = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { SAFE } }

def setup_grid!(first)
  coords = FILE.first(first).map { |l| l.chomp.split(',').map(&:to_i).reverse }
  GRID.each_index { |i| GRID[0].each_index { |j| GRID[i][j] = SAFE } }
  coords.each  { |i, j| GRID[i][j] = CORRUPTED }
end

def bfs_from(start_i, start_j)
  seen = Set.new
  queue = [[start_i, start_j, 0]]

  until queue.empty?
    i, j, dist = queue.shift
    next if seen.include?([i, j])
    seen << [i, j]
    next if GRID[i][j] == CORRUPTED

    return dist if i == GRID.length - 1 && j == GRID[0].length - 1
    # add neighbors
    neighbors(i, j, GRID).each { |i2, j2| queue << [i2, j2, dist + 1] }
  end
  nil
end

def run_bfs!(first)
  setup_grid!(first)
  bfs_from(0, 0)
end

puts run_bfs!(1024)

# Part 2
def binary_search(lower = 0, upper = FILE.length - 1)
  mid = (upper - lower) / 2 + lower
  if lower == upper # terminate here
    return lower - 1 if run_bfs!(lower).nil? && run_bfs!(lower - 1)
  end

  # if midpoint fails to bfs, go right
  if run_bfs!(mid).nil?
    binary_search(lower, mid)
  else
    binary_search(mid + 1, upper)
  end
end

puts FILE[binary_search]
