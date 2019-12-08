#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	l.scan(/([LR])(\d+)/).freeze
}[0].freeze

input = input.map { |d, v| [d, v.to_i] }
print(input, "\n")

directions = { "NL"=>"W", "NR"=>"E", "EL"=>"N", "ER"=>"S", "SL"=>"E", "SR"=>"W", "WL"=>"S", "WR"=>"N" }
steps = { "N"=>[0, -1], "E"=>[1, 0], "S"=>[0, 1], "W"=>[-1, 0] }

#input.each {|l|
#	print(l, "\n")
#}
print steps, "\n"

visited = [[0,0]]
x=0
y=0
act_dir = "N"

found = false
input.each { |leftright, n|
	act_dir = directions[act_dir+leftright]
	dx = steps[act_dir][0]
	dy = steps[act_dir][1]
#	print("#{leftright} dir: #{act_dir} '#{steps[act_dir]}', dx: '#{dx}' dy: '#{dy} n: '#{n}''\n")
	if not found 
		if dx != 0
			(1..n).each { 
				x += dx 
				if ([[x, y]] - visited).empty?
					print("P2 distance: #{x.abs+y.abs}\n")
					found = true
				end
#				print [x,y], visited, "\n"
				visited += [[x,y]]
			}
		end
		if dy != 0
			(1..n).each { 
				y += dy 
				if ([[x, y]] - visited).empty?
					print("P2 distance: #{x.abs+y.abs}\n")
					found = true
				end
#				print [x,y], visited, "\n"
				visited += [[x,y]]
			}
		end
	else
		x += n*dx
		y += n*dy
	end
#	print("x: #{x} y: #{y}\n")
}
print("P1 distance: #{x.abs+y.abs}\n")


__END__
R4, R3, R5, L3, L5, R2, L2, R5, L2, R5, R5, R5, R1, R3, L2, L2, L1, R5, L3, R1, L2, R1, L3, L5, L1, R3, L4, R2, R4, L3, L1, R4, L4, R3, L5, L3, R188, R4, L1, R48, L5, R4, R71, R3, L2, R188, L3, R2, L3, R3, L5, L1, R1, L2, L4, L2, R5, L3, R3, R3, R4, L3, L4, R5, L4, L4, R3, R4, L4, R1, L3, L1, L1, R4, R1, L4, R1, L1, L3, R2, L2, R2, L1, R5, R3, R4, L5, R2, R5, L5, R1, R2, L1, L3, R3, R1, R3, L4, R4, L4, L1, R1, L2, L2, L4, R1, L3, R4, L2, R3, L1, L5, R4, R5, R2, R5, R1, R5, R1, R3, L3, L2, L2, L5, R2, L2, R5, R5, L2, R3, L5, R5, L2, R4, R2, L1, R3, L5, R3, R2, R5, L1, R3, L2, R2, R1
