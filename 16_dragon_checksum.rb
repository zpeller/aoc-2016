#!/usr/bin/ruby

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:strip)[0].freeze

def next_state(s)
	s + '0' + s.reverse.tr('01', '10')
end

def generate_input(init_state, disc_size)
	disc_data = init_state
	begin
		disc_data = next_state(disc_data)
	end while disc_data.length < disc_size
	return disc_data[0, disc_size]
end

def calc_checksum(s)
	cksum = s
	begin
		cksum = cksum.chars.each_slice(2).map {|x, y| (x==y)?("1"):("0")}.join('')
	end while cksum.length % 2 == 0
	cksum
end


#disc_size = 20
#init_state = '10000'

init_state = input
s1 = generate_input(init_state, 272)
print("P1 checksum: #{calc_checksum(s1)}\n")

init_state = input
s1 = generate_input(init_state, 35651584)
print("P2 checksum: #{calc_checksum(s1)}\n")



__END__
10011111011011001
