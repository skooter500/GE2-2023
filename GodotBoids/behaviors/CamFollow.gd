extends Spatial

var target
var cam


# Called when the node enters the scene tree for the first time.
func _ready():
	target = get_parent().find_node("camTarget", true)
	cam = get_parent().find_node("Camera", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# transform.origin += transform.basis.z
	cam.global_translation = lerp(cam.global_translation, target.global_translation, delta * 5)
	cam.look_at(target.get_parent_spatial().global_translation, Vector3.UP)
	# pass
