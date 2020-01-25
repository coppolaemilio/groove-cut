extends Spatial


var direction = ['down']
var pos = Vector3(0,0,0)
var speed = 0.3

func _ready():
	pass # Replace with function body.

func _process(delta):
	pos[2] += speed * delta
	translate(pos)
