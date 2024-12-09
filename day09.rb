# Part 1

input = File.read('data09.txt').chomp.chars.map(&:to_i)

# input = '2333133121414131402'.chars.map(&:to_i)

EMPTY = '.'.freeze

# Each fileblock is run-length encoded:
runs = []

input.each_slice(2).each_with_index do |(file_length, empty_space), i|
  runs << [i, file_length]
  runs << [EMPTY, empty_space] unless empty_space.nil?
end

def viz(runs)
  runs.map { |x, count| x.to_s * count }.join
end

right_pointer = runs.length - 1
left_pointer = 0
while right_pointer > left_pointer
  # puts viz(runs)
  val, count = runs[right_pointer]
  left_val, left_count = runs[left_pointer]

  if val == EMPTY
    right_pointer -= 1
  else # we need to migrate this val to the left
    if left_val != EMPTY
      left_pointer += 1
    else # ok, time to migrate. Let's see if it fits?
      if count < left_count # it's smaller than the empty spots
        # First empty-ify the current segment
        runs[right_pointer][0] = EMPTY
        # Then add the current segment and shrink the smaller segment
        runs.insert(left_pointer, [val, count])
        runs[left_pointer + 1][1] = left_count - count
        left_pointer += 1 # shift right!
      elsif count > left_count # it expands past that segment
        # First, fill the left segment
        runs[left_pointer][0] = val
        # Then shorten the right segment
        runs[right_pointer][1] = count - left_count
        # And add blanks on the end
        runs.insert(right_pointer + 1, [EMPTY, left_count])
      else # it fits perfectly! Let's just swap them
        runs[left_pointer][0] = val
        runs[right_pointer][0] = EMPTY
        left_pointer += 1
        right_pointer -= 1
      end
    end
  end
end

def checksum(runs)
  id = 0
  sum = 0
  runs.each do |val, len|
    next if val == EMPTY
    len.times do
      sum += val * id
      id += 1
    end
  end
  sum
end

# puts viz(runs)
puts checksum(runs)
