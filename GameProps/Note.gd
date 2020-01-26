extends Spatial

var NoteSegment = load("res://GameProps/NoteSegment.tscn")
var TestCutter = load("res://GameProps/TestCutter.tscn")

var vr_mode = false

var cutter
var cutterKinematic

var pos = Vector3(0,0,0)
var speed = 0.6
var cutter_speed = 5
var cut_separation_force = 0.3;

var start_cut = false
var is_cut = false

#Placeholder, choosing random cut point and direction
var rand_val_x_1
var rand_val_y_1
var rand_val_x_2
var rand_val_y_2

var cutter_start_point = Vector3(0, 0, 0)
var cutter_target_point = Vector3(0, 0, 0)
var cutter_direction = Vector3(0, 0, 0)

func _ready():
	
	if get_parent().get_parent() != null and get_parent().get_parent().name == 'Spatial':
		vr_mode = get_parent().get_parent().vr_mode
		
	if !vr_mode:
				
		cutter = TestCutter.instance()
		cutterKinematic = cutter.get_node('CutterKinematic')
		get_parent().get_parent().get_node('NonVRCutters').add_child(cutter)
		cutter.translation.z = 20
		
		rand_val_x_1 = rand_range(-2,2)
		rand_val_y_1 = rand_range(-2,2)
		rand_val_x_2 = rand_range(-0.25,0.25)
		rand_val_y_2 = rand_range(-0.25,0.25)
		
		cutter_start_point = Vector3(rand_val_x_1, rand_val_y_1, 0)
		cutter_target_point = Vector3(rand_val_x_2, rand_val_y_2, 0)

func _process(delta):
	
	pos[2] += speed * delta
	translate(pos)
	
	if !vr_mode && cutter != null:
		
		if pos.z > 0.25 and !start_cut:
			
			start_cut = true
			cutter.translation = translation + cutter_start_point
			cutter.translation.z = translation.z
			cutter.rotate_x(deg2rad(-90.0))
			
			#DONT DELETE!! <<<------------
			#Use this line to force the direction to be towards the center of the Note
			cutter_direction = translation - cutter.translation
			#---------->
			
			#Give some variation, so it doesn't always try to go towards the center
			#cutter_direction = to_global(cutter_target_point) - cutter.translation
			
			cutter_direction = cutter_direction.normalized()
			cutter_direction.z = 0
			
		elif start_cut:
			
			cutter.translation.z = translation.z + 2.5
			var collision_info = cutterKinematic.move_and_collide(cutter_direction * cutter_speed 
				* delta)
			
			if collision_info:
				
				if collision_info.collider == get_node("DirectionalNote") or collision_info.collider == get_node("AllDirectionsNote"):
				
					var collision_position_local = to_local(collision_info.position)
					collision_position_local.z = 0
					
					print(collision_position_local)
					
					cut_note(collision_position_local, cutter_direction)

func cut_note(cut_point, cut_direction):
	is_cut = true
	visible = false
		
	instance_and_init_note_segment(cut_point, cut_direction, false)
	#We substract the second instance so it mirrors the first segment
	instance_and_init_note_segment(cut_point, cut_direction, true)
	
	queue_free()
	
	if cutter != null:
		cutter.queue_free()

func instance_and_init_note_segment(cut_point, cut_direction, isSubtraction):
	
	var rigidBody 
	var intersection_box
	var impulse_force_magnitude = cut_separation_force
	
	var note_segment = NoteSegment.instance()

	get_parent().get_parent().get_node('NoteSegments').add_child(note_segment)

	note_segment.translation = translation
	note_segment.rotation = rotation
	note_segment.get_node('DirectionalNote').visible = get_node("DirectionalNote").visible
	note_segment.get_node('AllDirectionsNote').visible = get_node("AllDirectionsNote").visible

	intersection_box = note_segment.get_node('DirectionalNote/CSGPolygon/IntersectionBox')

	if get_node("DirectionalNote").visible:
		intersection_box = note_segment.get_node('DirectionalNote/CSGPolygon/IntersectionBox')
		rigidBody = note_segment.get_node('DirectionalNote')
	elif get_node("AllDirectionsNote").visible:
		intersection_box = note_segment.get_node('AllDirectionsNote/CSGPolygon/IntersectionBox')
		rigidBody = note_segment.get_node('AllDirectionsNote')

	if isSubtraction:
		intersection_box.set_operation(2)
		impulse_force_magnitude *= -1;

	var desiredPos = Vector3(cut_point)
	desiredPos.z = 1
	intersection_box.translation = desiredPos
	
	var rotate_z_radians = atan2(-cut_direction.x, cut_direction.y)
	print(rad2deg(rotate_z_radians))
	intersection_box.rotate_z(rotate_z_radians)
	
	rigidBody.apply_impulse(Vector3(0,0,0), -transform.basis.x * impulse_force_magnitude)
