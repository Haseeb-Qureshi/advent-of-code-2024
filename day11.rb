# Part 1

input = File.read('data11.txt').chomp.split.map(&:to_i)

def step(input, times)
  times.times do
    input = input.reduce([]) do |acc, el|
      if el == 0
        acc << 1
      elsif el.to_s.length.even?
        s = el.to_s
        acc << s[0...s.length / 2].to_i
        acc << s[s.length / 2..-1].to_i
      else
        acc << el * 2024
      end
    end
  end
  input.length
end

puts step(input, 25)
