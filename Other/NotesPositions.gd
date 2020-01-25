extends Spatial

var Note = load("res://GameProps/Note.tscn")

var ns = 2.2 # Note spacing

var positions = [
	[Vector3(-ns,0,0), Vector3(0,0,0), Vector3(ns,0,0), Vector3(ns*2,0,0)],
	[Vector3(-ns,-ns,0), Vector3(0,-ns,0), Vector3(ns,-ns,0), Vector3(ns*2,-ns,0)],
	[Vector3(-ns,ns,0), Vector3(0,ns,0), Vector3(ns,ns,0), Vector3(ns*2,ns,0)]
]

func _ready():
	for n in range(12):
		var new_note = Note.instance()
		new_note.speed = 0
		if n == 0:
			new_note.translate(positions[0][0])
		if n == 1:
			new_note.translate(positions[0][1])
		if n == 2:
			new_note.translate(positions[0][2])
		if n == 3:
			new_note.translate(positions[0][3])
		
		
		if n == 4:
			new_note.translate(positions[1][0])
		if n == 5:
			new_note.translate(positions[1][1])
		if n == 6:
			new_note.translate(positions[1][2])
		if n == 7:
			new_note.translate(positions[1][3])
		
		if n == 8:
			new_note.translate(positions[2][0])
		if n == 9:
			new_note.translate(positions[2][1])
		if n == 10:
			new_note.translate(positions[2][2])
		if n == 11:
			new_note.translate(positions[2][3])
			
		get_parent().get_node('Notes').add_child(new_note)
