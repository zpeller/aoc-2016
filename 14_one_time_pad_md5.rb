#!/usr/bin/ruby

require 'digest'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze

#puts input

salt = input[0].strip

def gen_md5(salt, decimal, stretching_num, pop=true)
	md5input = salt + decimal.to_s
	if $md5hashes.key?(md5input)
		if pop
			md5hash = $md5hashes.pop(md5input)
		else
			md5hash = $md5hashes[md5input]
		end
	else
		md5hash = md5input
		(1..stretching_num+1).each {
			md5hash = Digest::MD5.hexdigest(md5hash)
		}
		if not pop
			$md5hashes[decimal] = md5hash
		end
	end
	return md5hash
end

def find_triplet(salt, start, stretching_num)
	decimal = start
	md5hash = ''
	while md5hash !~ /(.)\1\1/
		decimal += 1
		md5hash = gen_md5(salt, decimal, stretching_num)
	end
	return decimal, md5hash
end

def check_triplet_for_five(salt, start, triplet_char, stretching_num)
	fivelet_re = Regexp.new(triplet_char*5)
	(start..(start+999)).each { |decimal|
		if (gen_md5(salt, decimal, stretching_num, false) =~ fivelet_re) != nil
			return true
		end
	}
	return false
end

def find_64_keys(salt, stretching_num)
	index = -1
	num_keys = 0
	while num_keys < 64
		index, hash = find_triplet(salt, index, stretching_num)
		triplet_char = hash.scan(/(.)\1\1/)[0][0]
		if check_triplet_for_five(salt, index+1, triplet_char, stretching_num)
			num_keys += 1
			print "#{num_keys} #{index} #{hash}\n"
		end
	end
	return index
end
	
$md5hashes = {}
print("P1 secret: #{find_64_keys(salt, 0)}\n")

$md5hashes = {}
print("P2 secret (2016): #{find_64_keys(salt, 2016)}\n")

#print("P2 secret: #{eight_secret_chars_complex(secret_key)}\n")

	
#while md5hash[0, 6] != '000000'
#	decimal += 1
#	md5string = secret_key + decimal.to_s
#	md5hash = Digest::MD5.hexdigest(md5string)
#end
#
#print("6 zero decimal: #{decimal} md5string: #{md5string} md5hash: #{md5hash}\n")



__END__
yjdafjpo
