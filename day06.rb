# Part 1

require_relative 'helpers.rb'

GRID = File.readlines('data06.txt').map(&:chomp).map(&:chars)
EMPTY = '.'
SEEN = 'X'
OBSTACLE = '#'
ME = '^'

ORIENTATIONS = [
  [-1, 0], # up
  [0, 1], # right
  [1, 0], # down
  [0, -1], # left
]

def next_orientation(orientation)
  arr = ORIENTATIONS + ORIENTATIONS
  arr[arr.find_index(orientation) + 1]
end

orientation = ORIENTATIONS[0]
i, j = nil, nil
GRID.each_index do |i2|
  GRID[0].each_index do |j2|
    i, j = i2, j2 if GRID[i2][j2] == ME
  end
end

GRID[i][j] = SEEN

def next_position(orientation, i, j)
  [i + orientation[0], j + orientation[1]]
end

loop do
  i2, j2 = next_position(orientation, i, j)
  if !in_grid?(GRID, i2, j2)
    break
  elsif GRID[i2][j2] == OBSTACLE
    orientation = next_orientation(orientation)
  else
    GRID[i2][j2] = SEEN
    i, j = i2, j2
  end
end

puts GRID.sum { |row| row.count { |el| el == SEEN } }
