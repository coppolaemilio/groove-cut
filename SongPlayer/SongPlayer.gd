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

var ns = 2.2 # Note spacing
var positions = [
	[Vector3(-ns,0,0), Vector3(0,0,0), Vector3(ns,0,0), Vector3(ns*2,0,0)],
	[Vector3(-ns,-ns,0), Vector3(0,-ns,0), Vector3(ns,-ns,0), Vector3(ns*2,-ns,0)],
	[Vector3(-ns,ns,0), Vector3(0,ns,0), Vector3(ns,ns,0), Vector3(ns*2,ns,0)]
]

var Note = load("res://GameProps/Note.tscn")
var current_song = "./MapExampleCalibration/EasyStandard.dat"
var song_data = {}
var note_index = 0
var notes_on_track = []

func _ready():
	var song_data = global.read_json_file(current_song)
	for note in song_data['_notes']:
		print(note)
		notes_on_track.append(positions[note['_lineLayer']][note['_lineIndex']])
	$Timer.start(2)

func _on_Timer_timeout():
	var new_note = Note.instance()
	var current_direction = randi()%directionEnumSize
	
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
	
	new_note.translate(notes_on_track[note_index])
	note_index += 1
	get_parent().get_node('Notes').add_child(new_note)
