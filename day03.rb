# Part 1

input = File.read('data03.txt').chomp

muls = input.scan(/mul\(\d+,\d+\)/)
puts muls.sum { |s| s.scan(/\d+/).map(&:to_i).reduce(:*) }
