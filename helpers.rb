def in_grid?(grid, i, j)
  (0...grid.length).include?(i) && (0...grid[0].length).include?(j)
end
