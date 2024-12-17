# Part 1

WALL = '#'.freeze
EMPTY = '.'.freeze
ROBOT = '@'.freeze
BOX = 'O'.freeze
LEFT_BOX = '['.freeze
RIGHT_BOX = ']'.freeze

DIRS = {
  '>' => [0, 1],
  'v' => [1, 0],
  '^' => [-1, 0],
  '<' => [0, -1],
}

input = File.readlines('data15.txt').map(&:chomp)
GRID = []
GRID << input.shift.chars until input.first.empty?
instructions = input.drop(1).join.chars
LOC = []
GRID.each_index do |i|
  GRID[0].each_index do |j|
    LOC << i && LOC << j if GRID[i][j] == ROBOT
  end
end

def process_step!(instruction)
  di, dj = DIRS[instruction]
  i, j = LOC
  case GRID[i + di][j + dj]
  when EMPTY # safe to move
    LOC[0] += di
    LOC[1] += dj
    GRID[i][j] = EMPTY
    GRID[i + di][j + dj] = ROBOT
  when WALL # can't move
  when BOX # compute how far the boxes can move or if at all
    bi, bj = i + di, j + dj
    bi, bj = bi + di, bj + dj while GRID[bi][bj] == BOX
    case GRID[bi][bj]
    when EMPTY # swap the boxes
      LOC[0] += di
      LOC[1] += dj
      GRID[bi][bj] = BOX
      GRID[i + di][j + dj] = ROBOT
      GRID[i][j] = EMPTY
    when WALL # can't move
    else raise "Wait what? Why is there a #{GRID[bi][bj]}"
    end
  else raise 'wtf is this?'
  end
end

def gps_score(i, j)
  100 * i + j
end

def gps_sum
  GRID.each_with_index.sum do |row, i|
    row.each_index.sum do |j|
      GRID[i][j] == BOX ? gps_score(i, j) : 0
    end
  end
end

instructions.each { |instr| process_step!(instr) }
puts gps_sum

# Part 2

input = File.readlines('data15.txt').map(&:chomp)

GRID.clear
until input.first.empty?
  line = input.shift
  GRID << line.chars.map do |c|
    case c
    when WALL then WALL + WALL
    when BOX then LEFT_BOX + RIGHT_BOX
    when EMPTY then EMPTY + EMPTY
    when ROBOT then ROBOT + EMPTY
    else raise 'whoa wut?'
    end
  end
end

GRID.each_index do |i|
  GRID[0].each_index do |j|
    LOC[0] = i && LOC[1] = j if GRID[i][j] == ROBOT
  end
end

def process_step!(instruction)
  di, dj = DIRS[instruction]
  i, j = LOC
  case GRID[i + di][j + dj]
  when EMPTY # safe to move
    LOC[0] += di
    LOC[1] += dj
    GRID[i][j] = EMPTY
    GRID[i + di][j + dj] = ROBOT
  when WALL # can't move
  when LEFT_BOX, RIGHT_BOX # compute how far the boxes can move or if at all
    try_to_move_wide_box!(i, j, di, dj)
  else raise 'wtf is this?'
  end
end

def try_to_move_wide_box!(i, j, di, dj)
  if GRID[i + di][j + dj] == LEFT_BOX
    left = [i + di, j + dj]
    right = [i + di, j + dj + 1]
  else
    left = [i + di, j + dj - 1]
    right = [i + di, j + dj]
  end
  # Blank out both sides so you don't run into yourself
  GRID[left[0][left[1]] = EMPTY
  GRID[right[0][right[1]] = EMPTY
  # Try to push both left and right (must both have empty spots for both)
  left[0] += di
  left[1] += dj
  right[0] += di
  right[1] += dj
  # See if they collide with anything
  new_left = GRID[left[0]]


  # Remember to place back both sides of the box
end
