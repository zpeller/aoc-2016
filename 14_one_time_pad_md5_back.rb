#!/usr/bin/ruby

require 'digest'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze

#puts input

salt = input[0].strip

def gen_md5(salt, decimal, stretching_num)
	md5input = salt + decimal.to_s
	return $md5hashes[md5input] if $md5hashes.key?(md5input)

	md5hash = md5input
	(stretching_num+1).times {
		md5hash = Digest::MD5.hexdigest(md5hash)
	}
	$md5hashes[decimal] = md5hash
end

def find_fivelet(salt, start, stretching_num)
	md5hash = ''
	decimal = start + 1
	loop {
		md5hash = gen_md5(salt, decimal, stretching_num)
		break if (md5hash =~ /(.)\1\1\1\1/) != nil
		decimal += 1
	}
#	print ("#{decimal}:#{md5hash}\n")
	return decimal, md5hash
end

def check_fivelet_for_three(salt, start_pos, end_pos, triplet_char, stretching_num)
	(start_pos..end_pos).each { |decimal|
		triplet = $md5hashes[decimal].scan(/(.)\1\1/)
		if triplet.length>0
			return true, decimal if triplet[0][0] == triplet_char
		end
	}
	return false, 0
end

def find_64_keys(salt, stretching_num)
	num_keys = 0
	found_keys = []
	index = -1
	while num_keys < 64 or index < found_keys.sort[63] + 1000
		index, hash = find_fivelet(salt, index, stretching_num)
		fivelet_char = hash.scan(/(.)\1\1\1\1/)[0][0]
		start_pos = index - 1000
		end_pos = index -1
		while start_pos < end_pos
			found, found_pos = check_fivelet_for_three(salt, [start_pos, 0].max, end_pos, fivelet_char, stretching_num)
			break if not found

			found_keys << found_pos
			num_keys += 1
#			print "#{index} #{num_keys} #{found_pos} #{$md5hashes[found_pos]} #{hash}\n"
			start_pos = found_pos + 1
		end
	end
	return found_keys.sort[63]
end
	
$md5hashes = {}
print("P1 secret: #{find_64_keys(salt, 0)}\n")

$md5hashes = {}
print("P2 secret (2016): #{find_64_keys(salt, 2016)}\n")


__END__
yjdafjpo
