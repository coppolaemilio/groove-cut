extends Control

var songs_dir = 'user://'

var discovered_songs = []

func _ready():
	var listed_dir = global.list_dir(songs_dir)
	for dir in listed_dir:
		var info_path = songs_dir + dir + '/info.dat'
		var file = File.new()
		file.open(info_path, File.READ)
		var result = ''
		while not file.eof_reached():
		    var line = file.get_line()
		    result += line
		file.close()
		var data = parse_json(result)
		print(data['_songAuthorName'])
		var item_name = data['_songName'] + " by " + data['_songAuthorName']
		$ItemList.add_item(item_name, null, true)
		var sprite = crate_sprite(songs_dir + dir + '/' + data['_coverImageFilename'])
		
		discovered_songs.append([data, songs_dir + dir, sprite])
		$Cover.texture = sprite
		
		print(songs_dir + dir + '/' + data['_coverImageFilename'])


func _on_ItemList_item_selected(index):
	$Cover.texture = discovered_songs[index][2]


func crate_sprite(path):
	var img = Image.new()
	var err = img.load(path)
	if(err != 0):
		print("error loading the image: " + path)
		return null
	var img_tex = ImageTexture.new()
	img_tex.create_from_image(img)

	return img_tex
