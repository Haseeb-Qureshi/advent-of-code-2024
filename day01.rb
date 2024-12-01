# Part 1

input = File.readlines("data01.txt").map(&:chomp).map(&:split).map { |line| line.map(&:to_i) }

left_list = input.map(&:first).sort!
right_list = input.map(&:last).sort!

puts left_list.zip(right_list).map { |l, r| (l - r).abs }.sum
