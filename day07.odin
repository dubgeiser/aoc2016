package main

import "core:fmt"
import "core:strings"

import input "aoc/input"


/*
	An ABBA is any four-character sequence which consists of a pair of two
	different characters followed by the reverse of that pair, such as xyyx or
	abba
*/
is_palindrome :: proc(s: string, l: int = 4) -> bool {
	_, found := find_palindromes(s, l)
	return found
}

find_palindromes :: proc(s: string, l: int) -> ([]string, bool) {
	palindromes := make([dynamic]string)
	found := false
	for i := 0; i < len(s) - (l - 1); i += 1 {
		sub_s, _ := strings.substring(s, i, i + l)
		if sub_s[0] != sub_s[1] && sub_s == strings.reverse(sub_s) {
			append(&palindromes, sub_s)
			found = true
		}
	}
	return palindromes[:], found
}

extract_networks :: proc(ip: string) -> ([dynamic]string, [dynamic]string) {
	supernet := [dynamic]string{}
	hypernet := [dynamic]string{}
	parts := strings.split(ip, "[")
	for i := 0; i < len(parts); i += 1 {
		if strings.index(parts[i], "]") > -1 {
			sparts := strings.split(parts[i], "]")
			append(&hypernet, sparts[0])
			append(&supernet, sparts[1])
		} else {
			append(&supernet, parts[i])
		}
	}
	return supernet, hypernet
}

/*
	Given:
	xuabbxdwkutpsogcfea[tgetfqpgstsxrokcemk]cbftstsldgcqbxf[vwjejomptmifhdulc]ejeroshnazbwjjzofbe

	Split on [, giving:
		0. xuabbxdwkutpsogcfea
		1. tgetfqpgstsxrokcemk]cbftstsldgcqbxf
		2. vwjejomptmifhdulc]ejeroshnazbwjjzofbe

	Then split strings with ] on ], giving:
		0. xuabbxdwkutpsogcfea
		1. tgetfqpgstsxrokcemk
		2. cbftstsldgcqbxf
		3. vwjejomptmifhdulc
		4. ejeroshnazbwjjzofbe
	
	We can check on ], indicating that we have a hypernet
*/
supports_tls :: proc(ip: string) -> bool {
	supernet, hypernet := extract_networks(ip)
	defer delete(supernet)
	defer delete(hypernet)
	for s in hypernet {
		if is_palindrome(s) {
			return false
		}
	}
	for s in supernet {
		if is_palindrome(s) {
			return true
		}
	}
	return false
}

/*
	An IP supports SSL if it has an Area-Broadcast Accessor, or
	ABA, anywhere in the supernet sequences (outside any square
	bracketed sections), and a corresponding Byte Allocation
	Block, or BAB, anywhere in the hypernet sequences. An ABA is
	any three-character sequence which consists of the same
	character twice with a different character between them, such
	as xyx or aba. A corresponding BAB is the same characters but
	in reversed positions: yxy and bab, respectively.
*/
supports_ssl :: proc(ip: string) -> bool {
	supernet, hypernet := extract_networks(ip)
	defer delete(supernet)
	defer delete(hypernet)
	for s in supernet {
		pals, found := find_palindromes(s, 3)
		found or_continue
		for p in pals {
			p_inv := string([]byte{p[1], p[0], p[1]})
			for h in hypernet {
				if strings.contains(h, p_inv) {
					return true
				}
			}
		}
	}
	return false
}

main :: proc() {
	part1 := 0
	part2 := 0
	lines, _ := input.read_lines()
	for line in lines {
		if supports_tls(line) {
			part1 += 1
		}
		if supports_ssl(line) {
			part2 += 1
		}
	}
	fmt.println(part1)
	fmt.println(part2)
}
