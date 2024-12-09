# Part 1

input = File.read('data09.txt').chomp.chars.map(&:to_i)

EMPTY = '.'.freeze

# Each fileblock is run-length encoded:
original_runs = []

input.each_slice(2).each_with_index do |(file_length, empty_space), i|
  original_runs << [i, file_length]
  original_runs << [EMPTY, empty_space] unless empty_space.nil?
end

def viz(runs)
  runs.map { |x, count| x.to_s * count }.join
end

runs = original_runs.map(&:dup)

right_pointer = runs.length - 1
left_pointer = 0
while right_pointer > left_pointer
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
    len.times do
      sum += val * id unless val == EMPTY
      id += 1
    end
  end
  sum
end

puts checksum(runs)

# Part 2

runs = original_runs.map(&:dup)

right_pointer = runs.length - 1
left_pointer = 0
while right_pointer >= 0
  val, count = runs[right_pointer]
  left_val, left_count = runs[left_pointer]

  if right_pointer == left_pointer # found no matches
    right_pointer -= 1
    left_pointer = 0
  elsif val == EMPTY
    right_pointer -= 1
  else # we need to try to migrate this val to the left
    if left_val != EMPTY
      left_pointer += 1
    else
      if count < left_count # it's smaller than the empty spot
        runs[right_pointer][0] = EMPTY
        runs.insert(left_pointer, [val, count])
        runs[left_pointer + 1][1] = left_count - count
        right_pointer -= 1 # We're done with this segment, go left
        left_pointer = 0
      elsif count > left_count # it expands past that segment
        left_pointer += 1 # Keep scanning right.
      else # it fits perfectly! Let's just swap them
        runs[left_pointer][0] = val
        runs[right_pointer][0] = EMPTY
        left_pointer = 0
        right_pointer -= 1
      end
    end
  end
end

puts checksum(runs)
