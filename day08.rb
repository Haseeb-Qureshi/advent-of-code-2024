# Part 1
EMPTY = '.'.freeze
ANTINODE = '#'.freeze
require_relative 'helpers'

class File
  def self.readlines(s)
    '............
  ........0...
  .....0......
  .......0....
  ....0.......
  ......A.....
  ............
  ............
  ........A...
  .........A..
  ............
  ............'.lines
  end
end

grid = File.readlines('data08.txt').map(&:chomp).map(&:chars)

# Find slope of line segment between each pair

antennae = Hash.new { |h, k| h[k] = [] }
grid.each_index do |i|
  grid[0].each_index do |j|
    antennae[grid[i][j]] << [i, j] if grid[i][j] != EMPTY
  end
end

antinodes = Array.new(grid.length) { Array.new(grid[0].length) { EMPTY } }

# Project line segment in grid from each endpoint of pair
antennae.each_value do |instances|
  instances.combination(2).each do |point_a, point_b|
    x1, y1 = point_a
    x2, y2 = point_b
    dx = x1 - x2
    dy = y1 - y2
    [[x1 + dx, y1 + dy], [x2 - dx, y2 - dy]].each do |x, y|
      # Mark them as antinodes on the separate grid
      antinodes[x][y] = ANTINODE if in_grid?(antinodes, x, y)
    end
  end
end

puts antinodes.flatten.count(ANTINODE)
