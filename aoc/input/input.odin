package input

import "core:os"
import "core:strings"

// Read lines from a given file name.
// If no file name was given, read from STDIN.
read_lines :: proc(fn := "") -> ([]string, os.Error) {
	f, err := file_or_stdin(fn)
	defer os.close(f)
	if err != nil do return {}, err
	content, err_read := os.read_entire_file(f, context.allocator)
	if err_read != nil do return {}, err_read
	lines, err_mem := strings.split_lines(strings.trim_space(string(content)))
	return lines, err_mem
}

// Read the contents of a file name as 1 string.
// If no file name was given, read from STDIN.
read_one_string :: proc(fn := "") -> (string, os.Error) {
	f, err := file_or_stdin(fn)
	defer os.close(f)
	if err != nil do return "", err
	content, err_read := os.read_entire_file(f, context.allocator)
	if err_read != nil do return "", err_read
	return strings.trim_space(string(content)), nil
}

// Return a file handle for a given file name, or STDIN if no name given.
file_or_stdin :: proc(fn := "") -> (^os.File, os.Error) {
	f := os.stdin
	err_open: os.Error
	if fn != "" {
		f, err_open = os.open(fn)
		if err_open != nil {
			return nil, err_open
		}
	}
	return f, nil
}
