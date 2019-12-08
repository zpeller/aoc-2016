#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
#	l.scan(/-?\d+/).map(&:to_i).freeze
	if l =~ / .* /
		tokens = l.scan(/^(...) (.|-?\d+) (.|-?\d+)$/)[0].freeze
		[tokens[0], tokens[1], tokens[2]]
	else
		tokens = l.scan(/^(...) (.*)$/)[0].freeze
		[tokens[0], tokens[1]]
	end
}.freeze

#print(input, "\n")

#input.each {|l|
#	print(l, "\n")
#}

def run_program(input, regc)
	instr_ptr = 0
	cnt = -1
	regs = {"a"=>0, "b"=>0, "c"=>regc, "d"=>0}
	while instr_ptr>=0 and instr_ptr<input.length
		instr = input[instr_ptr][0]
		arg1 = input[instr_ptr][1]
		cnt += 1
#		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n")

		case instr
		when 'cpy'
			if "abcd".include?(arg1)
				arg1_val = regs[arg1]
			else
				arg1_val = arg1.to_i
			end
			arg2 = input[instr_ptr][2]
			regs[arg2] = arg1_val
		when 'inc'
			regs[arg1] += 1
		when 'dec'
			regs[arg1] -= 1
		when 'jnz'
			if "abcd".include?(arg1)
				arg1_val = regs[arg1]
			else
				arg1_val = arg1.to_i
			end
			if arg1_val > 0
				arg2 = input[instr_ptr][2]
				instr_ptr += arg2.to_i
				next
			end
		end
		instr_ptr += 1
	end
	return regs["a"]
end


print("Problem 1 reg a: " + run_program(input, 0).to_s + "\n")
print("Problem 2 reg a: " + run_program(input, 1).to_s + "\n")

__END__
cpy 1 a
cpy 1 b
cpy 26 d
jnz c 2
jnz 1 5
cpy 7 c
inc d
dec c
jnz c -2
cpy a c
inc a
dec b
jnz b -2
cpy c b
dec d
jnz d -6
cpy 16 c
cpy 12 d
inc a
dec d
jnz d -2
dec c
jnz c -5
