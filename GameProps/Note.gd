extends Spatial

var NoteSegment = load("res://GameProps/NoteSegment.tscn")

var pos = Vector3(0,0,0)
var speed = 0.6

var is_cut = false;

func _ready():
	
	pass # Replace with function body.

func _process(delta):
	
	pos[2] += speed * delta
	translate(pos)
	
	#If it reaches near the Camera and it has not been cut (testing purposes, 
	#change afterwards)
	if pos.z > 1.2 and !is_cut:
		
		#Placeholder, choosing random cut point and direction
		var rand_val_1 = rand_range(0,1)
		var rand_val_2 = rand_range(0,1)
		
		var cut_point = Vector3(rand_val_1, 1 - rand_val_1, 0)
		var cut_direction = Vector3(rand_val_2, 1 - rand_val_2, 0)
		
		cut_note(cut_point, cut_direction)

func cut_note(cut_point, cut_direction):
	is_cut = true
	visible = false
		
	instance_and_init_note_segment(cut_point, cut_direction, false)
	#We substract the second instance so it mirrors the first segment
	instance_and_init_note_segment(cut_point, cut_direction, true)
	
	queue_free()

func instance_and_init_note_segment(cut_point, cut_direction, isSubtraction):
	
	var rigidBody 
	var impulseForceMagnitude = 1.5;
	var intersection_box
	
	var note_segment = NoteSegment.instance()

	get_parent().get_parent().get_node('NoteSegments').add_child(note_segment)

	note_segment.translation = translation
	note_segment.rotation = rotation
	note_segment.get_node('DirectionalNote').visible = get_node("DirectionalNote").visible
	note_segment.get_node('AllDirectionsNote').visible = get_node("AllDirectionsNote").visible


	intersection_box = note_segment.get_node('DirectionalNote/CSGBox/IntersectionBox')

	if get_node("DirectionalNote").visible:
		intersection_box = note_segment.get_node('DirectionalNote/CSGBox/IntersectionBox')
		rigidBody = note_segment.get_node('DirectionalNote')
	elif get_node("AllDirectionsNote").visible:
		intersection_box = note_segment.get_node('AllDirectionsNote/CSGBox/IntersectionBox')
		rigidBody = note_segment.get_node('AllDirectionsNote')

	if isSubtraction:
		intersection_box.set_operation(2)
		impulseForceMagnitude *= -1;

	var desiredPos = intersection_box.translation + Vector3(cut_point)
	intersection_box.translation = desiredPos
	
	var rotate_z_radians = atan2(cut_direction.x, cut_direction.y)
	intersection_box.rotate_z(rotate_z_radians)
	
	rigidBody.apply_impulse(Vector3(0,0,0), intersection_box.transform.basis.x * impulseForceMagnitude)
