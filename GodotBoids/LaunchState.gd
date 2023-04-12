class_name LaunchState extends State

onready var base = get_node("../../Base")

var boid

func _enter():
	var target = base.global_transform + base.global_transform.z * 20
	boid.get_node("Seek").world_target = target
	boid.get_node("Seek").enabled = true

func _exit():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
