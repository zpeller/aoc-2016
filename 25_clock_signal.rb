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

def run_program(input, rega)
	instr_ptr = 0
	output = ''
	cnt = -1
	regs = {"a"=>rega, "b"=>0, "c"=>0, "d"=>0}
	while instr_ptr>=0 and instr_ptr<input.length
		instr = input[instr_ptr][0]
		arg1 = input[instr_ptr][1]
		cnt += 1
#		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n")

		case instr
		when 'out'
			if "abcd".include?(arg1)
				arg1_val = regs[arg1]
			else
				arg1_val = arg1.to_i
			end
			output << arg1_val.to_s
			return output if output.length==12
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

def find_lowest_int(input)
	rv = 0
	0.step {|n|
		print n, "\n" if n % 1000 == 0
		out = run_program(input, n)
#		print n,':', out, "\n"
		if out == '01'*6
			rv = n
			break
		end
	}
	return rv
end


print("Problem 1 reg a: " + find_lowest_int(input).to_s + "\n")
print("Problem 2: just click!\n")

__END__
cpy a d
cpy 9 c
cpy 282 b
inc d
dec b
jnz b -2
dec c
jnz c -5
cpy d a
jnz 0 0
cpy a b
cpy 0 a
cpy 2 c
jnz b 2
jnz 1 6
dec b
dec c
jnz c -4
inc a
jnz 1 -7
cpy 2 b
jnz c 2
jnz 1 4
dec b
dec c
jnz 1 -4
jnz 0 0
out b
jnz a -19
jnz 1 -21
