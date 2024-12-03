# Part 1

input = File.read('data03.txt').chomp

muls = input.scan(/mul\(\d+,\d+\)/)
puts muls.sum { |s| s.scan(/\d+/).map(&:to_i).reduce(:*) }

# Part 2
instructions = input.scan(/(mul\(\d+,\d+\)|don\'t\(\)|do\(\))/).flatten
enabled = true

mult = instructions.reduce(0) do |acc, el|
  val = 0
  if el == "don't()"
    enabled = false
  elsif el == "do()"
    enabled = true
  elsif enabled
    val = el.scan(/\d+/).map(&:to_i).reduce(:*)
  end
  acc + val
end

puts mult
