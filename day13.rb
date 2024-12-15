# Part 1
input = File.readlines('data13.txt').map(&:chomp) + [""]

buttons = input.each_slice(4).reduce([]) do |acc, (a, b, p, _)|
  acc << [a, b, p].flat_map do |s|
    s.scan(/\d+/).map(&:to_i)
  end
end

tokens = 0
buttons.each do |(ax, ay, bx, by, px, py)|
  # Solve the system of equations
  lcm = ax.lcm(ay)
  bx2 = bx * lcm / ax
  px2 = px * lcm / ax
  by2 = by * lcm / ay
  py2 = py * lcm / ay
  right_side = px2 - py2
  left_side = bx2 - by2
  b = right_side.fdiv(left_side)
  a = (px - bx * b).fdiv(ax)

  # See if there is a whole number & positive solution
  next if a % 1 > 0 || b % 1 > 0
  next if a < 0 || b < 0

  # Add the tokens
  tokens += a * 3 + b
end

puts tokens
