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

def reg_or_value(regs, arg)
	if "abcd".include?(arg)
		regs[arg]
	else
		arg.to_i
	end
end

def tgl_mod(instr)
	case instr
	when 'inc'
		'dec'
	when 'dec', 'tgl'
		'inc'
	when 'jnz'
		'cpy'
	when 'cpy'
		'jnz'
	end
end

def run_program(program, rega)
	program = Marshal.load(Marshal.dump(program))

	instr_ptr = 0
	cnt = -1
	regs = {"a"=>rega, "b"=>0, "c"=>0, "d"=>0}
	while instr_ptr>=0 and instr_ptr<program.length
		instr = program[instr_ptr][0]
		arg1 = program[instr_ptr][1]
		cnt += 1
		print("#{cnt} #{instr_ptr} i: #{instr} a1: #{arg1} #{regs}\n") if cnt%10000000 == 0 

		case instr
		when 'tgl'
			arg1_val = reg_or_value(regs, arg1)
			tgl_ptr = instr_ptr + arg1_val
			if tgl_ptr >= 0 and tgl_ptr < program.length
				program[tgl_ptr][0] = tgl_mod(program[tgl_ptr][0])
			end
		when 'cpy'
			arg1_val = reg_or_value(regs, arg1)
			arg2 = program[instr_ptr][2]
			regs[arg2] = arg1_val if "abcd".include?(arg2)
		when 'inc'
			regs[arg1] += 1
		when 'dec'
			regs[arg1] -= 1
		when 'jnz'
			arg1_val = reg_or_value(regs, arg1)
			if arg1_val > 0
				arg2 = program[instr_ptr][2]
				instr_ptr += reg_or_value(regs, arg2)
				next
			end
		end
#		program.each_with_index{|l,i| print i,l,"\n"}
		instr_ptr += 1
	end
	return regs["a"]
end


print("Problem 1 reg a: " + run_program(input, 7).to_s + "\n")
print("Problem 2 reg a: " + run_program(input, 12).to_s + "\n")

__END__
cpy a b
dec b
cpy a d
cpy 0 a
cpy b c
inc a
dec c
jnz c -2
dec d
jnz d -5
dec b
cpy b c
cpy c d
dec d
inc c
jnz d -2
tgl c
cpy -16 c
jnz 1 c
cpy 73 c
jnz 82 d
inc a
inc d
jnz d -2
inc c
jnz c -5
