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
# GRID = '###############
# #.......#....E#
# #.#.###.#.###.#
# #.....#.#...#.#
# #.###.#####.#.#
# #.#.#.......#.#
# #.#.#####.###.#
# #...........#.#
# ###.#.#####.#.#
# #...#.....#.#.#
# #.#.#.###.#.#.#
# #.....#...#.#.#
# #.###.#.#.#.#.#
# #S..#.....#...#
# ###############'.lines.map(&:chomp).map(&:chars)

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
  # system 'clear'
end

def bfs_from(i, j)
  # Do BFS with a priority queue
  queue = PQueue.new { |a, b| a.last < b.last }
  queue << [i, j, ORIENTATIONS[1], Set.new([[i, j]]), 0]
  seen = Hash.new { |h, k| h[k] = 0 }
  first_ending_cost = nil
  return_key = nil
  shortest_path_here = Hash.new { |h, k| h[k] = [Float::INFINITY, Set.new]}

  until queue.empty?
    i, j, orientation, path, cost = queue.pop

    best_cost, predecessors = shortest_path_here[[i, j, orientation]]
    if cost < best_cost
      shortest_path_here[[i, j, orientation]] = [cost, path]
    elsif cost == best_cost
      shortest_path_here[[i, j, orientation]] = [cost, predecessors + path]
    end

    # require 'pry'; binding.pry if i == 7 && j == 5
    # if i == 7 && j == 6
    #   puts [i, j, orientation, path, cost].join(' ')
    #   puts display_path(path)
    # end

    next if seen[[i, j, orientation]] > 10
    seen[[i, j, orientation]] += 1
    next if !in_grid?(GRID, i, j)
    next if GRID[i][j] == WALL
    if GRID[i][j] == 'E'
      if first_ending_cost.nil? # first time reaching the end!
        first_ending_cost = cost
        return_key = [i, j, orientation]
      else # we've already gotten to the end
        # require 'pry'; binding.pry
        # p shortest_path_here if cost > first_ending_cost
        return shortest_path_here[return_key] if cost > first_ending_cost
      end
    end

    # add to queue: advance
    i2 = i + orientation[0]
    j2 = j + orientation[1]

    queue << [i2, j2, orientation, path + [[i2, j2, orientation]], cost + 1] unless path.include?([i2, j2, orientation])
    # add to queue: turning left and turning right
    rotations(orientation).each do |new_orientation|
      queue << [i, j, new_orientation, path, cost + 1000]
    end
  end
end

cost, pathed_nodes = bfs_from(i, j)
puts cost

# Part 2

puts pathed_nodes.size
puts display_path(pathed_nodes).join.count("O")
puts display_path(pathed_nodes)
