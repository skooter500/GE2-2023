class_name LaunchState extends State

var base 

var boid
var target

func _enter():
	target = base.global_transform.origin + base.global_transform.basis.z * 20
	boid.get_node("Seek").world_target = target
	boid.get_node("Seek").set_enabled(true)

func _exit():
	boid.get_node("Seek").set_enabled(false)
	pass

func _think():
	if target.distance_to(boid.global_transform.origin) < 5:
		boid.get_node("StateMachine").change_state(DefendState.new())

func get_class():
	return "LaunchState"
	
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	base = get_node("../../Base")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
