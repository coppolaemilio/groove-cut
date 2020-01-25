extends Node

var Note = load("res://GameProps/Note.tscn")

var current_song = []

func _on_Timer_timeout():
	var new_note = Note.instance()
	var directions = ['up', 'down', 'left', 'right', 'all']
	var current_direction = directions[randi()%directions.size()]
	
	match current_direction:
		'up':
			new_note.rotate_z(deg2rad(180.0))
		'left':
			new_note.rotate_z(deg2rad(270.0))
		'right':
			new_note.rotate_z(deg2rad(90.0))
		'all':
			new_note.get_node('DirectionalNote').visible = false
	
	if current_direction != 'all':
		new_note.get_node('AllDirectionsNote').visible = false
	
	print(current_direction)
	
	get_parent().get_node('Notes').add_child(new_note)
