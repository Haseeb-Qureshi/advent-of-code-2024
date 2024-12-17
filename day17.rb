# Part 1

# class File
#   def self.readlines(s)
#     'Register A: 729
# Register B: 0
# Register C: 0

# Program: 0,1,5,4,3,0'.lines
#   end
# end
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

cpu = CPU.new(a, b, c, 0, program)
puts cpu.run!.join(',')
