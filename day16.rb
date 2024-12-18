# Part 1

require 'pqueue'
require_relative 'helpers'

WALL = '#'.freeze
EMPTY = '.'.freeze
ME = 'S'.freeze

ORIENTATIONS = [
  [-1, 0], # up
  [0, 1], # right
  [1, 0], # down
  [0, -1], # left
]

GRID = File.readlines('data16.txt').map(&:chomp).map(&:chars)

i, j = nil, nil
GRID.each_index do |i2|
  GRID[0].each_index do |j2|
    if GRID[i2][j2] == ME
      i, j = i2, j2
      GRID[i2][j2] = EMPTY
    end
  end
end

def rotations(orientation)
  ors = ORIENTATIONS + ORIENTATIONS
  i = ors.index(orientation)
  [ors[i + 1], ors[i - 1]]
end

def display_path(path)
  new_grid = GRID.map(&:dup)
  path.each { |(i, j)| new_grid[i][j] = 'O' }
  new_grid.map(&:join)
end

def bfs_from(i, j)
  # Do BFS with a priority queue
  queue = PQueue.new { |a, b| a.last < b.last }
  queue << [i, j, ORIENTATIONS[1], Set.new([[i, j, ORIENTATIONS[1]]]), 0]
  seen = Set.new
  paths_here = Hash.new { |h, k| h[k] = [Float::INFINITY, Set.new]}

  until queue.empty?
    i, j, orientation, path, cost = queue.pop

    lowest_cost, path_here = paths_here[[i, j, orientation]]
    paths_here[[i, j, orientation]] = [cost, path_here + path] if cost <= lowest_cost

    next if seen.include?([i, j, orientation])
    seen << [i, j, orientation]
    next if !in_grid?(GRID, i, j)
    next if GRID[i][j] == WALL
    return cost, path, paths_here if GRID[i][j] == 'E'

    # add to queue: advance
    i2 = i + orientation[0]
    j2 = j + orientation[1]

    queue << [i2, j2, orientation, path + [[i2, j2, orientation]], cost + 1]
    # add to queue: turning left and turning right
    rotations(orientation).each do |new_orientation|
      queue << [i, j, new_orientation, path + [[i, j, new_orientation]], cost + 1000]
    end
  end
end

cost, path, paths_here = bfs_from(i, j)
puts cost

# Part 2

def all_nodes_from(i, j, o, paths_here, cache = {})
  path = paths_here[[i, j, o]].last
  cache[[i, j, o]] = path if path.length <= 2
  return cache[[i, j, o]] if cache[[i, j, o]]

  path.each do |i2, j2, o2|
    next if i2 == i && j2 == j && o2 == o
    path += all_nodes_from(i2, j2, o2, paths_here, cache)
  end
  cache[[i, j, o]] ||= path
end

i, j, o = paths_here.keys.find { |i, j, o| i == 1 && j == GRID[0].length - 2 }
puts all_nodes_from(i, j, o, paths_here).uniq { |(i, j)| [i, j] }.count
