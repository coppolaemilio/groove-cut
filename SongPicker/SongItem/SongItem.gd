extends HBoxContainer


func init(data, texture):
	$CoverArt.texture = texture
	$Labels/SongName.text = data['_songName']
	$Labels/AuthorName.text = data['_songAuthorName'] + ' [' + data['_levelAuthorName'] + ']'
