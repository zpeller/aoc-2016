#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_i)[0].freeze

# print(input, "\n")

def elf_with_lefthand_presents(num_elves)
	elf_list = (1..num_elves).to_a
	while elf_list.length > 1
		elf_list << elf_list.shift
		elf_list.shift
	end
	return elf_list.first
end

def elf_with_opposite_presents(num_elves)
	half = num_elves/2

	right_list = (1..half).to_a
	left_list = (half+1..num_elves).to_a

	while left_list.length + right_list.length > 1
		left_list.shift
		left_list << right_list.shift
		if left_list.length - right_list.length > 1
			right_list << left_list.shift
		end
	end
	return left_list.first
end

print("P1 lefthand elf with all presents: #{elf_with_lefthand_presents(input)}\n")
print("P2 opposite elf with all presents: #{elf_with_opposite_presents(input)}\n")
print("P1n lefthand elf with all presents: #{elf_with_lefthand_presents(5*10**8)}\n")

__END__
3005290
