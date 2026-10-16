package aoc

import "core:os"
import "core:strings"

/*
Read lines from a given file name.
If no file name was given, read from STDIN.
*/
read_lines :: proc(fn: string = "") -> ([]string, os.Error) {
	f := os.stdin
	err_open: os.Error
	if fn != "" {
		f, err_open = os.open(fn)
		if err_open != nil {
			return {}, err_open
		}
	}
	content, err_read := os.read_entire_file(f, context.allocator)
	defer os.close(f)
	if err_read != nil {
		return {}, err_read
	}
	lines, err_mem := strings.split_lines(strings.trim_space(string(content)))
	return lines, err_mem
}
