#!/usr/bin/ruby

require 'set'

input = 1358
$dest_coords = [31, 39]

#input = 10
#$dest_coords = [7, 4]

$start_pos = [1, 1]
$map_width, $map_height = 55, 55

def is_wall(x, y, favnum)
	num_d = x*x + 3*x + 2*x*y + y + y*y + favnum
	num_b = "%b" % num_d
	one_bits = num_b.chars.select{ |x| x=='1' }.length
	return ((one_bits % 2) == 1)
end

def init_maze(width, height, favnum)
	maze = []
	(0..height).each { |y|
		maze_line = []
		(0..width).each { |x|
			maze_line += [(is_wall(x, y, favnum)? "#":".")]
		}
		maze += [maze_line]
		print maze_line.join(''), "\n"
	}
	return maze
end

def adjacent_field_coords(x, y, w, h)
	field_coords = []
    if x < w-1
        field_coords << [x+1, y]
	end
    if y < h-1
        field_coords << [x, y+1]
	end
    if x>0
        field_coords << [x-1, y]
	end
    if y>0
        field_coords << [x, y-1]
	end
    return field_coords
end

def find_num_steps(building_map)
#	building_map = Marshal.load(Marshal.dump(building_map))

    move_level = 1
    building_map[$start_pos[1]][$start_pos[0]] = 0

	prev_step_list = Set.new
	prev_step_list.add([1, 1])

    while not prev_step_list.empty?
		next_step_list = Set.new
		prev_step_list.each {|c_x, c_y|
			adjacent_field_coords(c_x, c_y, $map_width, $map_height).each { |x, y|
				if building_map[y][x]=='.' 
					building_map[y][x] = move_level
					next_step_list.add?([x, y])
					if x == $dest_coords[0] and y == $dest_coords[1]
						return move_level
					end
				end
			}
		}
		prev_step_list = next_step_list
        move_level += 1
	end
end

def count_max_50_steps(building_map)
	count_50 = 0
	(0..$map_height-2).each { |y|
		(0..$map_width-2).each { |x|
			if building_map[y][x].class == Fixnum and building_map[y][x]<=50
				count_50 += 1
			end
		}
	}
	return count_50
end


maze = init_maze($map_width, $map_height, input)
#print maze, "\n"
print("P1 num steps: #{find_num_steps(maze)}\n")
print("P2 max 50 steps: #{count_max_50_steps(maze)}\n")


__END__
