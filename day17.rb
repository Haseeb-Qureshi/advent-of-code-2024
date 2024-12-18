# Part 1

ia, ib, ic, _, iprogram = File.readlines('data17.txt').map(&:chomp)
a = ia.split.last.to_i
b = ib.split.last.to_i
c = ic.split.last.to_i
program = iprogram.split.last.split(',').map(&:to_i)

class CPU < Struct.new(:a, :b, :c, :i, :program)
  def run!
    @output = []
    while i < program.length
      op!(program[i], program[i + 1])
      self.i += 2
    end
    @output
  end

  def op!(opcode, operand)
    combo = case operand
    when (0..3) then operand
    when 4 then self.a
    when 5 then self.b
    when 6 then self.c
    else nil
    end

    case opcode
    when 0
      self.a = self.a / (2 ** combo)
    when 1
      self.b = b ^ operand
    when 2
      self.b = combo % 8
    when 3
      self.i = operand - 2 unless self.a == 0
    when 4
      self.b = self.b ^ self.c
    when 5
      @output << combo % 8
    when 6
      self.b = self.a / (2 ** combo)
    when 7
      self.c = self.a / (2 ** combo)
    end
  end
end

# cpu = CPU.new(a, b, c, 0, program)
# puts cpu.run!.join(',')
#
# Part 2
# self.b = a % 8
# self.b = b ^ 7
# self.c = self.a / (2 ** self.b)
# self.b = b ^ 7
# self.b = self.b ^ self.c
# self.a = self.a / (2 ** 3)
# @output << b % 8
# self.i = operand - 2 unless self.a == 0
#
# Simplify:
# loop ->
#   @output << a % 8 ^ (a / (2 ** ((a ^ 7) % 8))) % 8
#             bottom 3 XOR a / 2 ** (NOT bottom 3)
#   a =/ 8

# Make a table going from right to left of how to create these and shift the left
COMPUTE = proc { |n| CPU.new(n, 0, 0, 0, program).run! }
table = Hash.new { |h, k| h[k] = [] }
0.upto(2 ** 16).each { |n| table[compute.(n)] << n }

# program = [5, 5, 3, 0]
def find_as(remaining_program)
  # if we consumed everything but one, we good!
  return (0..7).select { |n| COMPUTE.(n) == remaining_program[0] } if remaining_program.length == 1

  (0..7).each do |n|
    # need to output: remaining_program.last
    candidates = find_as(remaining_program[1..])
  end

  find_as(remaining_program[1..])
  remaining_program.each_index do |i|
    next_chunk = table[remaining_program.first(i + 1)]
    next if next_chunk.nil?
    p [remaining_program.first(i), i]
    best_remaining = best_chunks(table, remaining_program.drop(i + 1), current_chunks = current_chunks + [next_chunk])
    return best_remaining if best_remaining
  end
  nil
end


# p best_chunks(table, program.reverse)


# until p2.empty?
#   cur.unshift(p2.pop)
#   if table[cur]
#     p [cur, val]
#     val <<= (3 * cur.length)
#     val ^= table[cur]
#     cur = []
#   end
# end
# puts val

# 89057482259288 is too low
