extends Spatial

var vr_mode = true

func _ready():
	if vr_mode:
		var VR = ARVRServer.find_interface("OpenVR")
		if VR and VR.initialize():
			get_viewport().arvr = true
			get_viewport().hdr = false
			
			OS.vsync_enabled = false
			#Engine.target_fps = 90
	else:
		$OVRFirstPerson.queue_free()
		$Camera.current = true
