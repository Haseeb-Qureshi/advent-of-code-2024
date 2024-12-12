# Part 1

require_relative 'helpers'
require 'colorize'

# class File
#   def self.readlines(s)
#     'RRRRIICCFF
# RRRRIICCCF
# VVRRRCCFFF
# VVRCCCJFFF
# VVVVCJJCFE
# VVIVCCJJEE
# VVIIICJJEE
# MIIIIIJJEE
# MIIISIJEEE
# MMMISSJEEE'.lines
#   end
# end

WALL = '.'.freeze
# Pad the grid with wall to make things easier
GRID = File.readlines('data12.txt').map { |l| (WALL + l.chomp + WALL).chars }
full_wall = [(WALL * GRID[0].length).chars]
GRID = full_wall.map(&:dup) + GRID + full_wall.map(&:dup)

VISITED = Array.new(GRID.length) { Array.new(GRID[0].length) { false } }

puts GRID.map(&:join)

def show_visited
  VISITED.map { |l| l.map { |bool| bool ? 'T' : 'F' }.join }
end

def area_from(i, j)
  char = GRID[i][j]
  queue = [[i, j]]
  area = 0
  until queue.empty?
    i2, j2 = queue.pop
    new_char = GRID[i2][j2]
    next if new_char != char
    next if VISITED[i2][j2]
    # Ok we're the same character!

    VISITED[i2][j2] = true
    area += 1
    queue.concat(neighbors(i2, j2, GRID))
  end
  area
end

def bordering_characters(i, j, char)
  neighbors(i, j, GRID).count { |i2, j2| char != GRID[i2][j2] }
end

def perimeter_from(i, j)
  char = GRID[i][j]
  queue = [[i, j]]
  perimeter = 0
  seen_in_perimeter = Set.new
  until queue.empty?
    i2, j2 = queue.pop
    new_char = GRID[i2][j2]
    next if new_char != char
    next if seen_in_perimeter.include?([i2, j2])

    seen_in_perimeter << [i2, j2]

    if bordering_characters(i2, j2, char) > 0
      # Ok we're a valid perimeter!
      perimeter += bordering_characters(i2, j2, char)
    end
    queue.concat(neighbors(i2, j2, GRID))
  end
  # p seen_in_perimeter
  # seen_in_perimeter.each { |i, j| GRID[i][j] = 'P'.blue }
  # puts GRID.map(&:join)
  # p ["Perimeter: ", char, perimeter]
  perimeter
end

total_price = 0
GRID.each_index do |i|
  GRID[0].each_index do |j|
    next if VISITED[i][j] || GRID[i][j] == WALL
    area = area_from(i, j)
    perimeter = perimeter_from(i, j)
    total_price += area * perimeter
  end
end

puts total_price
