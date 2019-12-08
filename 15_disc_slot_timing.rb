#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map { |l|
	nums = l.scan(/-?\d+/).map(&:to_i)
	[nums[0], nums[1], nums[3]]
}.freeze

# print(input, "\n")

def init_discs(discs, input)
	input.each {|id, positions, pos0|
		discs[id] = [positions, pos0]
	}
end

discs = {}
init_discs(discs, input)
# print discs, "\n"

def position_at_time(disc_id, disc, time)
	(disc[1] + time) % disc[0]
end

def find_right_time(discs)
	0.step { |time|
		right_discs = 0
		discs.each_key {|disc_id|
			break if position_at_time(disc_id, discs[disc_id], time+disc_id) != 0
			right_discs += 1
		}
		return time if right_discs == discs.length
	}
end

def add_disc(discs, positions, pos0)
	disc_id = discs.keys.length + 1
	discs[disc_id] = [positions, pos0]
end
	
#print discs, "\n"
print("P1 closest time: #{find_right_time(discs)}\n")
add_disc(discs, 11, 0)
#print discs, "\n"
print("P2 closest time: #{find_right_time(discs)}\n")


__END__
Disc #1 has 7 positions; at time=0, it is at position 0.
Disc #2 has 13 positions; at time=0, it is at position 0.
Disc #3 has 3 positions; at time=0, it is at position 2.
Disc #4 has 5 positions; at time=0, it is at position 2.
Disc #5 has 17 positions; at time=0, it is at position 0.
Disc #6 has 19 positions; at time=0, it is at position 7.
