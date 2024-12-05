# Part 1

grid = File.readlines('data04.txt').map(&:chomp).map(&:chars)

SCANS = [
  [[-1, -1], [-2, -2], [-3, -3]],
  [[0, -1], [0, -2], [0, -3]],
  [[0, 1], [0, 2], [0, 3]],
  [[1, 0], [2, 0], [3, 0]],
  [[-1, 0], [-2, 0], [-3, 0]],
  [[1, 1], [2, 2], [3, 3]],
  [[1, -1], [2, -2], [3, -3]],
  [[-1, 1], [-2, 2], [-3, 3]],
]

def in_grid?(grid, i, j)
  (0...grid.length).include?(i) && (0...grid[0].length).include?(j)
end

def scanned_coord_paths(i, j, scans)
  scans.map { |diffs| diffs.map { |di, dj| [i + di, j + dj] } }
end

def splat(grid, i, j, scans)
  scanned_coord_paths(i, j, scans).select do |path|
    path.all? { |i2, j2| in_grid?(grid, i2, j2) }
  end.map do |path|
    path.map { |i2, j2| grid[i2][j2] }.join
  end
end

def find_xmas(grid)
  grid.each_with_index.sum do |(row, i)|
    row.each_with_index.sum do |(el, j)|
      grid[i][j] == 'X' ? splat(grid, i, j, SCANS).count('MAS') : 0
    end
  end
end

puts find_xmas(grid)

# Part 2

X_SCANS = [
  [[-1, -1], [1, 1]],
  [[-1, 1], [1, -1]],
]

def find_xes(grid)
  grid.each_with_index.sum do |(row, i)|
    row.each_with_index.sum do |(el, j)|
      if grid[i][j] == 'A'
        splats = splat(grid, i, j, X_SCANS).map { |s| s.chars.sort.join }

        splats.length == 2 && splats.all? { |s| s == 'MS' } ? 1 : 0
      else
        0
      end
    end
  end
end

puts find_xes(grid)
