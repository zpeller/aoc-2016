#!/usr/bin/ruby

require 'digest'

input = (ARGV.empty? ? DATA : ARGF).each_line.map(&:to_s).freeze

#puts input

secret_key = input[0].strip

def next_five_zero_md5(key, start)
	decimal = start
	hash_value = loop do
		md5hash = Digest::MD5.hexdigest("#{key}#{decimal}")
		break md5hash if md5hash[0, 5] == '00000'
		decimal += 1
	end
	return decimal, hash_value
end

def eight_secret_chars(key)
	decimal = -1
	passwd = ''

	8.times {
		decimal, hash = next_five_zero_md5(key, decimal+1)
		print("5 zero decimal: #{decimal} md5hash: #{hash}\n")
		passwd += hash[5]
	}
	return passwd
end

def eight_secret_chars_complex(key)
	decimal = -1
	passwd = 'xxxxxxxx'

	passchars_found = 0
	while passchars_found < 8 
		decimal, hash = next_five_zero_md5(key, decimal+1)
		print("5 zero decimal: #{decimal} md5hash: #{hash}\n")
		next if hash[5] !~ /[0-7]/
		pos = hash[5].to_i
		if passwd[pos] != 'x'
			next
		else
			passwd[pos] = hash[6]
			passchars_found += 1
		end
	end
	return passwd
end

print("P1 secret: #{eight_secret_chars(secret_key)}\n")
print("P2 secret: #{eight_secret_chars_complex(secret_key)}\n")

__END__
ffykfhsq
