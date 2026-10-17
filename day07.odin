package main

import "core:fmt"
import "core:strings"

import "aoc"


/*
	An ABBA is any four-character sequence which consists of a pair of two
	different characters followed by the reverse of that pair, such as xyyx or
	abba
*/
has_abba :: proc(s: string) -> bool {
	for i := 0; i < len(s) - 3; i += 1 {
		sub_s, _ := strings.substring(s, i, i + 4)
		if sub_s[0] != sub_s[1] && sub_s == strings.reverse(sub_s, context.allocator) {
			return true
		}
	}
	return false
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
	in_hypernet := [dynamic]string{}
	defer delete(in_hypernet)
	out_hypernet := [dynamic]string{}
	defer delete(out_hypernet)
	parts := strings.split(ip, "[")
	for i := 0; i < len(parts); i += 1 {
		if strings.index(parts[i], "]") > -1 {
			sparts := strings.split(parts[i], "]")
			append(&in_hypernet, sparts[0])
			append(&out_hypernet, sparts[1])
		} else {
			append(&out_hypernet, parts[i])
		}
	}
	for s in in_hypernet {
		if has_abba(s) {
			return false
		}
	}
	for s in out_hypernet {
		if has_abba(s) {
			return true
		}
	}
	return false
}

main :: proc() {
	part1 := 0
	lines, _ := aoc.read_lines()
	for line in lines {
		if supports_tls(line) {
			part1 += 1
		}
	}
	fmt.println(part1)
}
