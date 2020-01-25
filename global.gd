extends Node

var directory = Directory.new()

# Save file easy functions
func list_dir(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files

func read_json_file(path):
	var file = File.new()
	file.open(path, File.READ)
	var result = ''
	while not file.eof_reached():
		var line = file.get_line()
		result += line
	file.close()
	var data = parse_json(result)
	return data
