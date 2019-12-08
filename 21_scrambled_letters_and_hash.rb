#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.strip.scan(/^(\w+ \w+) (.*)$/)[0].freeze
	case tokens[0]
	when 'rotate left'
		[tokens[0], tokens[1][0].to_i]
	when 'rotate right'
		[tokens[0], -(tokens[1][0].to_i)]
	when 'rotate based'
		[tokens[0], tokens[1][-1]]
	when 'move position', 'reverse positions', 'swap position'
		[tokens[0], [tokens[1][0].to_i, tokens[1][-1].to_i]]
	when 'swap letter'
		[tokens[0], [tokens[1][0], tokens[1][-1]]]
	end
}.freeze

# print(input, "\n")

def scramble_password(password, commands)
	pwdc = password.chars
	commands.each {|cmd, args|
#		print pwdc.join, "\n"
		case cmd
		when 'rotate left', 'rotate right'
			pwdc = pwdc.rotate(args)
		when 'rotate based'
			idx = pwdc.index(args)
			rot_cnt = 1 + idx + (idx>=4?1:0)
			pwdc = pwdc.rotate(-rot_cnt)
		when 'move position'
			delc = pwdc.delete_at(args[0])
			pwdc.insert(args[1], delc)
		when 'reverse positions'
			sub = pwdc[args[0]..args[1]]
			pwdc = (pwdc-sub).insert(args[0], sub.reverse).flatten
		when 'swap position'
			pwdc[args[0]], pwdc[args[1]] = pwdc[args[1]], pwdc[args[0]]
		when 'swap letter'
			pwdc = pwdc.join.tr(args[0]+args[1], args[1]+args[0]).chars
		end
#		print(l, "\n")
	}
#	print pwdc, "\n"
	return pwdc.join
end

def unscramble_password(password, commands)
	pwdc = password.chars
	rev_rot = {}
	(0..7).each { |idx|
		rot_cnt = 1 + idx + (idx>=4?1:0)
		rot_pos = (idx + rot_cnt) % 8
		rev_rot [rot_pos] = rot_cnt
	}
#	print rev_rot, "\n"
	commands.reverse.each {|cmd, args|
#		print pwdc.join, "\n"
		case cmd
		when 'rotate left', 'rotate right'
			pwdc = pwdc.rotate(-args)
		when 'rotate based'
			idx = pwdc.index(args)
			rot_cnt = rev_rot[idx]
#			print idx, rot_cnt, "\n"
			pwdc = pwdc.rotate(rot_cnt)
		when 'move position'
			delc = pwdc.delete_at(args[1])
			pwdc.insert(args[0], delc)
		when 'reverse positions'
			sub = pwdc[args[0]..args[1]]
			pwdc = (pwdc-sub).insert(args[0], sub.reverse).flatten
		when 'swap position'
			pwdc[args[0]], pwdc[args[1]] = pwdc[args[1]], pwdc[args[0]]
		when 'swap letter'
			pwdc = pwdc.join.tr(args[0]+args[1], args[1]+args[0]).chars
		end
#		print(l, "\n")
	}
#	print pwdc, "\n"
	return pwdc.join
end

print("P1 scrambled password: #{scramble_password('abcdefgh', input)}\n")
print("P2 unscrambled password: #{unscramble_password('fbgdceah', input)}\n")

__END__
rotate right 4 steps
swap letter b with letter e
swap position 1 with position 3
reverse positions 0 through 4
rotate left 5 steps
swap position 6 with position 5
move position 3 to position 2
move position 6 to position 5
reverse positions 1 through 4
rotate based on position of letter e
reverse positions 3 through 7
reverse positions 4 through 7
rotate left 1 step
reverse positions 2 through 6
swap position 7 with position 5
swap letter e with letter c
swap letter f with letter d
swap letter a with letter e
swap position 2 with position 7
swap position 1 with position 7
swap position 6 with position 3
swap letter g with letter h
reverse positions 2 through 5
rotate based on position of letter f
rotate left 1 step
rotate right 2 steps
reverse positions 2 through 7
reverse positions 5 through 6
rotate left 6 steps
move position 2 to position 6
rotate based on position of letter a
rotate based on position of letter a
swap letter f with letter a
rotate right 5 steps
reverse positions 0 through 4
swap letter d with letter c
swap position 4 with position 7
swap letter f with letter h
swap letter h with letter a
rotate left 0 steps
rotate based on position of letter e
swap position 5 with position 4
swap letter e with letter h
swap letter h with letter d
rotate right 2 steps
rotate right 3 steps
swap position 1 with position 7
swap letter b with letter e
swap letter b with letter e
rotate based on position of letter e
rotate based on position of letter h
swap letter a with letter h
move position 7 to position 2
rotate left 2 steps
move position 3 to position 2
swap position 4 with position 6
rotate right 7 steps
reverse positions 1 through 4
move position 7 to position 0
move position 2 to position 0
reverse positions 4 through 6
rotate left 3 steps
rotate left 7 steps
move position 2 to position 3
rotate left 6 steps
swap letter a with letter h
rotate based on position of letter f
swap letter f with letter c
swap position 3 with position 0
reverse positions 1 through 3
swap letter h with letter a
swap letter b with letter a
reverse positions 2 through 3
rotate left 5 steps
swap position 7 with position 5
rotate based on position of letter g
rotate based on position of letter h
rotate right 6 steps
swap letter a with letter e
swap letter b with letter g
move position 4 to position 6
move position 6 to position 5
rotate based on position of letter e
reverse positions 2 through 6
swap letter c with letter f
swap letter h with letter g
move position 7 to position 2
reverse positions 1 through 7
reverse positions 1 through 2
rotate right 0 steps
move position 5 to position 6
swap letter f with letter a
move position 3 to position 1
move position 2 to position 4
reverse positions 1 through 2
swap letter g with letter c
rotate based on position of letter f
rotate left 7 steps
rotate based on position of letter e
swap position 6 with position 1
