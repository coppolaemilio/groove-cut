extends Spatial

# Code from https://docs.godotengine.org/en/3.1/tutorials/vr/vr_starter_tutorial.html
func _ready():
	return
	var VR = ARVRServer.find_interface("OpenVR")
	if VR and VR.initialize():
		get_viewport().arvr = true
		get_viewport().hdr = false
		
		OS.vsync_enabled = false
		#Engine.target_fps = 90
		# Also, the physics FPS in the project settings is also 90 FPS. This makes the physics
		# run at the same frame rate as the display, which makes things look smoother in VR!
# -------------------------------------
