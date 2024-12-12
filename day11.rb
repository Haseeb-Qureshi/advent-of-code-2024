# Part 1

input = File.read('data11.txt').chomp.split.map(&:to_i)

def next_state(val)
  case
  when val == 0
    [1]
  when val.to_s.length.even?
    s = val.to_s
    [s[0...s.length / 2], s[s.length / 2..-1]].map(&:to_i)
  else
    [val * 2024]
  end
end

def step(input, times)
  times.times do |i|
    input = input.flat_map { |el| next_state(el) }
  end
  input.length
end

puts step(input, 25)

# Part 2

CACHE = {}

class Node
  attr_reader :val, :children_at_height
  def initialize(val)
    @val = val
    @children_at_height = [0]
  end

  def children
    next_state(val).map { |el| CACHE[el] ||= Node.new(el) }
  end

  def num_children_at(depth)
    return children_at_height[depth] if children_at_height[depth]
    return children_at_height[1] = children.count if depth == 1
    children_at_height[depth] = children.sum { |child| child.num_children_at(depth - 1) }
  end
end

def dynamically_step(input, depth)
  # memoize each subtree
  nodes = input.map do |el|
    CACHE[el] ||= Node.new(el)
  end
  # Each subtree memoizes the number of children at each step (1, 2, 3, 4, 5) so you don't need to recompute it
  puts nodes.sum { |n| n.num_children_at(depth) }
end

puts dynamically_step(input, 75)
