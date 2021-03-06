extends Spatial

export var vr_mode = false

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
