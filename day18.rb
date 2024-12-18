# Part 1
require_relative 'helpers'
require 'pqueue'

SAFE = '.'.freeze
CORRUPTED = '#'.freeze

GRID_SIZE = 70 + 1
file = File.readlines('data18.txt')
# file = '5,4
# 4,2
# 4,5
# 3,0
# 2,1
# 6,3
# 2,4
# 1,5
# 0,6
# 3,3
# 2,6
# 5,1'.lines
coords = file.first(1024).map { |l| l.chomp.split(',').map(&:to_i).reverse }

GRID = Array.new(GRID_SIZE) { Array.new(GRID_SIZE) { SAFE } }
coords.each  { |i, j| GRID[i][j] = CORRUPTED }

def bfs_from(start_i, start_j)
  seen = Set.new
  queue = PQueue.new { |a, b| a.last < b.last }

  queue << [start_i, start_j, Set.new([[start_i, start_j]]), 1]
  until queue.empty?
    i, j, path, cost = queue.pop
    next if seen.include?([i, j])
    seen << [i, j]
    next if GRID[i][j] == CORRUPTED

    # viz_path(path)
    return cost  - 1 if i == GRID.length - 1 && j == GRID[0].length - 1
    # add neighbors
    neighbors(i, j, GRID).each { |i2, j2| queue << [i2, j2, path + [[i2, j2]], cost + 1]}
  end
end

def viz_path(path)
  path.each { |i, j| GRID[i][j] = 'O' }
  puts GRID.map(&:join)
  path.each { |i, j| GRID[i][j] = SAFE }
  puts
end

puts bfs_from(0, 0)
