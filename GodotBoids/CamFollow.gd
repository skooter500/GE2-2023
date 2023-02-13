extends Spatial

onready var target = find_node("camTarget")
onready var cam = get_node("Camera")

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# transform.origin += transform.basis.z
	cam.global_translation = lerp(cam.global_translation, target.global_translation, delta * 5)
	cam.look_at(target.get_parent_spatial().global_translation, Vector3.UP)
	# pass
