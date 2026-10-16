package aoc

import "core:fmt"
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
	content, err := os.read_entire_file(f, context.allocator)
	defer os.close(f)
	if err != nil {
		return {}, err
	}
	lines := strings.split(strings.trim(string(content), "\n"), "\n")
	return lines, nil
}
