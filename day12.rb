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
  span = [[i, j]]
  area = 0
  until queue.empty?
    i2, j2 = queue.pop
    new_char = GRID[i2][j2]
    next if new_char != char
    next if VISITED[i2][j2]
    # Ok we're the same character!

    VISITED[i2][j2] = true
    span << [i2, j2]
    area += 1
    queue.concat(neighbors(i2, j2, GRID))
  end
  [area, span]
end

def bordering_characters(i, j, char)
  neighbors(i, j, GRID).count { |i2, j2| char != GRID[i2][j2] }
end

def perimeter_from(i, j)
  char = GRID[i][j]
  queue = [[i, j]]
  perimeter = 0
  perimeter_path = Set.new
  seen_in_perimeter = Set.new
  until queue.empty?
    i2, j2 = queue.pop
    new_char = GRID[i2][j2]
    next if new_char != char
    next if seen_in_perimeter.include?([i2, j2])

    seen_in_perimeter << [i2, j2]

    if bordering_characters(i2, j2, char) > 0
      # Ok we're a valid perimeter!
      perimeter_path << [i2, j2]
      perimeter += bordering_characters(i2, j2, char)
    end
    queue.concat(neighbors(i2, j2, GRID))
  end

  [perimeter, perimeter_path]
end

total_price = 0
GRID.each_index do |i|
  GRID[0].each_index do |j|
    next if VISITED[i][j] || GRID[i][j] == WALL
    area, _ = area_from(i, j)
    perimeter, _ = perimeter_from(i, j)
    total_price += area * perimeter
  end
end

puts total_price

# Part 2

def sides_from(i, j)
  external_sides_from(i, j) + internal_sides_from(i, j)
end

def external_sides_from(i, j)
  _, perimeter_path = perimeter_from(i, j)
  traced = perimeter_path.zip([false].cycle).to_h

  start = [i, j]
  perimeter_path.delete(start)
  traced[start] = true
  direction = nil

  until perimeter_path.empty?
    # add the number of neighbors, that = sides
    # If you are going in the same direction, skip?
  end
  # Start at one node along the perimeter
  # Cases:
  #   Extend your hand to the left, how many corners do you feel?
  #   Each corner denotes a side
  #   How do you detect a corner? A corner is two adjacent squares are not part of the same structure (up & left), (down & left), (down & right), (up & right)
  #   If all 4 are not part of the same structure, you add 4 sides
  #   If 3 are not part of the same structure, you add 2 sides ??
  #   If 2 ADJACENTS are not part of the same structure BUT NO DIAG, you add 1 side
  #   If 2 ADJACENTS are not part of the same structure BUT YES TO DIAG, you add 2 sides
  #   If 1 is not part of the same structure, you add nothing
  #   F
  #   --
  #   FF
  #   --
  #   FFFF
  #   FFF
  #   --
  #   F
  #   FFFFF
  #    F
  #   --
  #   FF   3 + 1  4
  #    FF  1 + 1  6
  #     F  3      9 # Nope, my algorithm doesn't work. Think about this some more. Use pen and paper.
  # What if there's a single jutting out peninsula?
  # What if there's a ladder moving left and down?
end

# First, find the perimeter and return the perimeter path
# BFS the perimeter and count every time you change directions—that's a new side
# Then find internal sides
  #
