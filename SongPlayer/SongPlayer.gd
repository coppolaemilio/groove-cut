extends Node

enum NOTE_DIRECTION {
	Up,
	Down,
	Left,
	Right,
	UpLeft,
	UpRight,
	DownLeft,
	DownRight,
	All
}

var ns = 2.2 # Note spacing
var positions = [
	[Vector3(-ns,0,0), Vector3(0,0,0), Vector3(ns,0,0), Vector3(ns*2,0,0)],
	[Vector3(-ns,-ns,0), Vector3(0,-ns,0), Vector3(ns,-ns,0), Vector3(ns*2,-ns,0)],
	[Vector3(-ns,ns,0), Vector3(0,ns,0), Vector3(ns,ns,0), Vector3(ns*2,ns,0)]
]

# Note
var Note = load("res://GameProps/Note.tscn")
var RedMaterial = load("res://Theme/Materials/Red.tres")
var BlueMaterial = load("res://Theme/Materials/Blue.tres")

# Song
var current_song = "./MapExampleCalibration/Expert.dat"
var song_data = {}
var notes_on_track = []
var batches = []

var playing_index = 0

func _ready():
	var song_data = global.read_json_file(current_song)
	var batch_index = 0
	var current_batch = []
	
	for note in song_data['_notes']:
		if note['_time'] == batch_index:
			current_batch.append(note)
		else:
			batches.append(current_batch)
			current_batch = []
			batch_index = note['_time']
			current_batch.append(note)
			print(batch_index)
	
	for b in batches:
		print(b)
	print('[+] Batches size: ', batches.size())
	#$Timer.start(2)

func spawn_note(note):
	var new_note = Note.instance()
	get_parent().get_node('Notes').add_child(new_note)
	#var current_direction = randi()%NOTE_DIRECTION.size()
	var current_direction = int(note['_cutDirection'])
	
	new_note.translate(positions[note['_lineLayer']][note['_lineIndex']])
	
	match current_direction:
		NOTE_DIRECTION.Up:
			new_note.rotate_z(deg2rad(180.0))
		NOTE_DIRECTION.Down:
			new_note.rotate_z(deg2rad(0.0))
		NOTE_DIRECTION.Left:
			new_note.rotate_z(deg2rad(-90.0))
		NOTE_DIRECTION.Right:
			new_note.rotate_z(deg2rad(90.0))
		NOTE_DIRECTION.UpLeft:
			new_note.rotate_z(deg2rad(-135.0))
		NOTE_DIRECTION.UpRight:
			new_note.rotate_z(deg2rad(135.0))
		NOTE_DIRECTION.DownLeft:
			new_note.rotate_z(deg2rad(-45.0))
		NOTE_DIRECTION.DownRight:
			new_note.rotate_z(deg2rad(45.0))
		NOTE_DIRECTION.All:
			new_note.get_node('DirectionalNote').visible = false
		
	if current_direction != NOTE_DIRECTION.All:
		new_note.get_node('AllDirectionsNote').visible = false
	
	if note['_type'] == 0: # 0 Red, 1 Blue
		new_note.get_node('DirectionalNote/CSGBox').material_override = RedMaterial
		new_note.get_node('AllDirectionsNote/CSGBox').material_override = RedMaterial
	else:
		new_note.get_node('DirectionalNote/CSGBox').material_override = BlueMaterial
		new_note.get_node('AllDirectionsNote/CSGBox').material_override = BlueMaterial
	
	
	

func create_batch(batch):
	for note in batch:
		spawn_note(note)
	playing_index += 1

func _on_Timer_timeout():
	if batches.size() > playing_index:
		print('playing_index: ', playing_index)
		create_batch(batches[playing_index])
