extends Node

enum NOTE_DIRECTION {
	Down,
	Up,
	Left,
	Right,
	DownLeft,
	DownRight,
	UpLeft,
	UpRight,
	All
}

var directionEnumSize = 9;

var Note = load("res://GameProps/Note.tscn")

var current_song = []

func _on_Timer_timeout():
	var new_note = Note.instance()
	var current_direction = randi()%directionEnumSize
	
	current_direction = NOTE_DIRECTION.UpRight;
	
	match current_direction:
		NOTE_DIRECTION.Down:
			new_note.rotate_z(deg2rad(0.0))
		NOTE_DIRECTION.Up:
			new_note.rotate_z(deg2rad(180.0))
		NOTE_DIRECTION.Left:
			new_note.rotate_z(deg2rad(-90.0))
		NOTE_DIRECTION.Right:
			new_note.rotate_z(deg2rad(90.0))
		NOTE_DIRECTION.DownLeft:
			new_note.rotate_z(deg2rad(-45.0))
		NOTE_DIRECTION.DownRight:
			new_note.rotate_z(deg2rad(45.0))
		NOTE_DIRECTION.UpLeft:
			new_note.rotate_z(deg2rad(-135.0))
		NOTE_DIRECTION.UpRight:
			new_note.rotate_z(deg2rad(135.0))
		NOTE_DIRECTION.All:
			new_note.get_node('DirectionalNote').visible = false
		
	if current_direction != NOTE_DIRECTION.All:
		new_note.get_node('AllDirectionsNote').visible = false
	
	get_parent().get_node('Notes').add_child(new_note)
