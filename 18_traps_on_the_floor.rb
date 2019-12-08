#!/usr/bin/ruby

require 'set'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip)[0].freeze

print(input, "\n")

def is_it_trap(above)
	return ['^..', '^^.', '.^^', '..^'].include?(above)
end

def num_safe_tiles(first_line, max_rows)
	act_line = '.' + first_line + '.'
	safe_tiles_cnt = act_line.count('.')-2

	(max_rows-1).times {
		next_line='.'
		act_line.chars.each_cons(3) { |triplet|
			next_line += (is_it_trap(triplet.join(''))) ? '^':'.'
		}
		next_line += '.'
		safe_tiles_cnt += next_line.count('.')-2
		act_line = next_line
	}
	return safe_tiles_cnt
end

print("P1 safe tiles: #{num_safe_tiles(input, 40)}\n")
print("P2 safe tiles: #{num_safe_tiles(input, 400000)}\n")

__END__
^.....^.^^^^^.^..^^.^.......^^..^^^..^^^^..^.^^.^.^....^^...^^.^^.^...^^.^^^^..^^.....^.^...^.^.^^.^
