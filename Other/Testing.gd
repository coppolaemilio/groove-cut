extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	discover_songs()
	#get_tree().quit()
	#open_working_directory()

func discover_songs():
	var directory = Directory.new()
	for file in global.list_dir('user://'):
		if '.zip' in file:
			print(file)
			var current_file = OS.get_user_data_dir() + '/' + file
			var target_dir = OS.get_user_data_dir() + '/' + file.replace('.zip', '')
			if directory.dir_exists(target_dir) == false:
				match OS.get_name():
					'OSX':
						var out = []
						OS.execute('unzip', [current_file, '-d', target_dir], true, out, true)
						print(out)

func open_working_directory():
	match OS.get_name():
		'OSX':
			OS.execute('open', [OS.get_user_data_dir()], false)
		'Windows':
			OS.execute('open', [OS.get_user_data_dir()], false)
		'_':
			print('[!] Can\'t detect OS')
