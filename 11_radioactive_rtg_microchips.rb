#!/usr/bin/ruby

require 'set'

$debug = false
def dprint(*arg)
	if not $debug; return; end

	print(arg)
end

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	tokens = l.strip.scan(/ ([a-z]*)( generator|-compatible)/).map {|x| 
		if x[1]==" generator"
			["rtg", x[0]]
		else
			["chip", x[0]]
		end
	}.freeze
}.freeze

def init_floors(floors, input)
	input.each_with_index {|devices,index|
		floor_num = index+1
		floors[floor_num] = [[], []]
		devices.each { |device|
			if device[0] == 'rtg'
				floors[floor_num][0] += [device[1][0]]
			else
				floors[floor_num][1] += [device[1][0]]
			end
#		print floors[floor_num], "\n"
		}
	}
end

def floor_state(floors) 
	state=''
	(1..4).each { |floor|
		devices = floors[floor]
		state << floor.to_s
		state << "P"
		state << ':'*(devices[0] & devices[1]).length
		state << "G"
		(devices[0] - devices[1]).sort.each {|g|
			state << g[0]
		}
		state << "M"
		(devices[1] - devices[0]).sort.each {|m|
			state << m[0]
		}
	}
	return state
end

def real_dup(object)
	Marshal.load(Marshal.dump(object))
end

def floor_dup(floor)
	dup_floor = [[]*5]
	(1..4).each { |i| 
		dup_floor[i] = [floor[i][0].dup, floor[i][1].dup]
	}
	return dup_floor
end

def possible_moving_devices(rtg, chip)
	devs = []
	devs += rtg.combination(2).map{ |x| [[x[0],x[1]], []] }
	devs += chip.combination(2).map{ |x| [[], [x[0], x[1]]] }
	rtg.sort.each {|g|
		if chip.include?(g)
			devs += [[[g], [g]]]
			break
		end
	}
	devs += rtg.map{ |x| [[x], []]}
	devs += chip.map{ |x| [[], [x]]}
end

def do_move(floors, act_floor, next_floor, move, move_count)
	if move_count >= $min_moves or move_count>=63; return; end

	floors = floor_dup(floors)
	move[0].each {|rtg|
		floors[act_floor][0].delete(rtg)
		floors[next_floor][0] << rtg
	}
	move[1].each {|chip|
		floors[act_floor][1].delete(chip)
		floors[next_floor][1] << chip
	}
	
	next_state = floor_state(floors)
#	print("#{next_state}\n")
	if next_state == $dest_state
		$min_moves = move_count
		return
	end

	if $states_seen.key?(next_state) 
		if $states_seen[next_state] < move_count
			return
		end
	end
	$states_seen[next_state] = move_count
	if $states_seen.length % 1000 == 0
		print $states_seen.length, "\n"
	end

	next_move(floors, next_floor, move_count)
end

def unprotected_chips_in_move(move) 
	chips = []
	case move[1].length
	when 1
		if move[0].length != 1
			chips = move[1]
		end
	when 2
		chips = move[1]
	end
	return chips
end

def unprotected_chips_on_floor(floor) 
	floor[1]-floor[0]
end

def move_valid(floors, act_floor, move)
	act_floor_remaining_rtgs = floors[act_floor][0] - move[0]
	act_floor_remaining_chips = floors[act_floor][1] - move[1]
	act_floor_remaining_sets = act_floor_remaining_rtgs & act_floor_remaining_chips
	act_floor_remaining_rtgs -= act_floor_remaining_sets
	act_floor_remaining_chips -= act_floor_remaining_sets
	if act_floor_remaining_chips.length > 0 and act_floor_remaining_rtgs.length > 0
		return false, false
	end

	up_floor = act_floor+1
	down_floor = act_floor-1
	up_ok = true
	down_ok = true

	if down_floor<1
   		down_ok = false
	end
	if up_floor>4
   		up_ok = false
	end

	ucim = unprotected_chips_in_move(move) 
	if up_ok 
		if (ucim - floors[up_floor][0]).length > 0 and floors[up_floor][0].length > 0
			up_ok = false
		else
			ucof = unprotected_chips_on_floor(floors[up_floor])
			if (ucof - move[0]).length > 0 and move[0].length > 0
				up_ok = false
			end
		end
	end
	if down_ok
		if (ucim - floors[down_floor][0]).length > 0 and floors[down_floor][0].length > 0
			down_ok = false
		else
			ucof = unprotected_chips_on_floor(floors[down_floor])
			if (ucof - move[0]).length > 0 and move[0].length > 0
				down_ok = false
			end
		end
	end

	return up_ok, down_ok
end


def next_move(floors, act_floor, move_count)
	moves = possible_moving_devices(floors[act_floor][0], floors[act_floor][1])
	dprint moves, "\n"
	moves.each {|move|
		dprint move, "\n"
		up_ok, down_ok = move_valid(floors, act_floor, move)
		if up_ok
			do_move(floors, act_floor, act_floor+1, move, move_count+1)
		end
		if down_ok
			do_move(floors, act_floor, act_floor-1, move, move_count+1)
		end
	}
end

def calc_dest_state(floor)
	elements = floor.flatten.uniq
	return "1PGM2PGM3PGM4P#{':'*elements.length}GM"
end

$states_seen = {}
$min_moves = 10000000000

floors = [[]*5]
init_floors(floors, input)

$dest_state = calc_dest_state(floors).freeze
print floors, "\n", floor_state(floors), ":#{$dest_state}\n\n"

#next_move(floors, 1, 0)
#print("P1 min moves: #{$min_moves}\n")

floors[1][0] += ["e", "d"]
floors[1][1] += ["e", "d"]

$dest_state = calc_dest_state(floors).freeze
print floors, "\n", floor_state(floors), ":#{$dest_state}\n\n"

next_move(floors, 1, 0)
print("P2 min moves: #{$min_moves}\n")

__END__
The first floor contains a strontium generator, a strontium-compatible microchip, a plutonium generator, and a plutonium-compatible microchip.
The second floor contains a thulium generator, a ruthenium generator, a ruthenium-compatible microchip, a curium generator, and a curium-compatible microchip.
The third floor contains a thulium-compatible microchip.
The fourth floor contains nothing relevant.
