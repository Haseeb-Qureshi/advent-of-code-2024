def in_grid?(grid, i, j)
  (0...grid.length).include?(i) && (0...grid[0].length).include?(j)
end

def neighbors(i, j, grid)
  [
    [i + 1, j],
    [i - 1, j],
    [i, j + 1],
    [i, j - 1],
  ].select { |i2, j2| in_grid?(grid, i2, j2) }
end
