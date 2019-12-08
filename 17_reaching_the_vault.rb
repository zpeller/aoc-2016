#!/usr/bin/ruby

require 'set'
require 'digest'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip)[0].freeze

$start_pos = [0, 0]
$dest_coords = [3, 3]
$map_width, $map_height = 4, 4

def valid_move(x, y, move)
#	print x,y,move, "\n"
	case move
	when 'U'
		return y > 0, x, y-1
	when 'D'
		return y < $map_height-1, x, y+1
	when 'R'
		return x < $map_width-1, x+1, y
	when 'L'
		return x > 0, x-1, y
	else
		return false, 0, 0
	end
end

def possible_moves(key, path)
	moves = ''
	hash = Digest::MD5.hexdigest("#{key}#{path}")
	moves << 'U' if 'bcdef'.include?(hash[0])
	moves << 'D' if 'bcdef'.include?(hash[1])
	moves << 'L' if 'bcdef'.include?(hash[2])
	moves << 'R' if 'bcdef'.include?(hash[3])
	moves
end

def find_num_steps(passcode, find_longest)
    move_level = 1
	max_moves = 0
	position_list = Set.new
	position_list.add([$start_pos[0], $start_pos[1], ''])

	while not position_list.empty?
		next_position_list = Set.new
		position_list.each {|c_x, c_y, path|
#			print("#{c_x},#{c_y} #{path}\n")
			possible_moves(passcode, path).chars.each { |move|
#				print move, "\n"
				is_valid_move, n_x, n_y = valid_move(c_x, c_y, move)
				next if not is_valid_move
#				print("#{n_x},#{n_y} #{path}\n")
				if n_x == $dest_coords[0] and n_y == $dest_coords[1]
					if not find_longest
						return move_level,path+move
					else
						max_moves = move_level
						next
					end
				end
				next_position_list.add([n_x, n_y, path+move])
			}
		}
		position_list = next_position_list
        move_level += 1
	end
	return max_moves
end

#print maze, "\n"
print("P1 minimum_path: #{find_num_steps(input, false)}\n")
print("P2 maximum path length: #{find_num_steps(input, true)}\n")


__END__
udskfozm
