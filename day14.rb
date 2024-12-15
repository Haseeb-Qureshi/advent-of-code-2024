# Part 1

input = File.readlines('data14.txt').map(&:chomp)
LENGTH = 101
HEIGHT = 103
GRID = Array.new(HEIGHT) { Array.new(LENGTH) { 0 } }

class Robot < Struct.new(:x, :y, :dx, :dy)
  def advance!(steps = 1)
    GRID[y][x] -= 1 if @moved
    @moved = true
    self.x = (x + dx * steps) % LENGTH
    self.y = (y + dy * steps) % HEIGHT
    GRID[y][x] += 1
  end
end

robots = input.map do |line|
  Robot.new(*line.split.flat_map { |s| s[2..-1].split(',') }.map(&:to_i))
end

robots.each { |r| r.advance!(100) }
quadrants = [
  [(0...HEIGHT / 2), (0...LENGTH / 2)],
  [(0...HEIGHT / 2), (LENGTH / 2 + 1...LENGTH)],
  [(HEIGHT / 2 + 1...HEIGHT), (0...LENGTH / 2)],
  [(HEIGHT / 2 + 1...HEIGHT), (LENGTH / 2 + 1...LENGTH)],
]

product = quadrants.reduce(1) do |prod, (is, js)|
  prod * is.sum { |i| js.sum { |j| GRID[i][j] } }
end

puts product

# Part 2

GRID.each { |row| row.each_index { |i| row[i] = 0 } }

robots = input.map do |line|
  Robot.new(*line.split.flat_map { |s| s[2..-1].split(',') }.map(&:to_i))
end

def find_christmas_tree(robots, iter = 50_000)
  50_000.times do |i|
    robots.each(&:advance!)
    return i + 1 if GRID.all? { |row| row.max <= 1 }
  end
end

puts find_christmas_tree(robots)
