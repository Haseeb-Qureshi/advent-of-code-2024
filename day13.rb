# Part 1
input = File.readlines('data13.txt').map(&:chomp) + [""]

buttons = input.each_slice(4).reduce([]) do |acc, (a, b, p, _)|
  acc << [a, b, p].flat_map do |s|
    s.scan(/\d+/).map(&:to_i)
  end
end

def compute_tokens(buttons, offset = 0)
  buttons.sum do |(ax, ay, bx, by, px, py)|
    # Solve the system of equations
    lcm = ax.lcm(ay)
    bx2 = bx * lcm / ax
    px2 = (px + offset) * lcm / ax
    by2 = by * lcm / ay
    py2 = (py + offset) * lcm / ay
    right_side = px2 - py2
    left_side = bx2 - by2
    b = right_side.fdiv(left_side)
    a = (px + offset - bx * b).fdiv(ax)

    # See if there is a whole number & positive solution
    if a % 1 > 0 || b % 1 > 0
      0
    elsif a < 0 || b < 0
      0
    else
      # Add the tokens
      (a * 3 + b).to_i
    end
  end
end

puts compute_tokens(buttons)

# Part 2

puts compute_tokens(buttons, 10_000_000_000_000)
