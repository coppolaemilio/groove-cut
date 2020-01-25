extends Node

var Note = load("res://GameProps/Note.tscn")

var current_song = []

func _on_Timer_timeout():
	var new_note = Note.instance()
	var directions = ['up', 'down', 'left', 'right', 'block']
	var current_direction = directions[randi()%directions.size()]
	
	if current_direction == 'up':
		print('up')
	else:
		print('default')
	
	print(current_direction)
	
	new_note.get_node('AllDirectionsNote').visible = false
	get_parent().get_node('Notes').add_child(new_note)
