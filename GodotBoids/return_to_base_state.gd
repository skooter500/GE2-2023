class_name ReturnToBase extends State

var boid
var base
var target

func _enter():
	boid = get_parent()
	base = get_node("../../Base")
	target = base.global_transform.origin + base.global_transform.basis.z * 20
	boid.get_node("Seek").world_target = target
	boid.get_node("Seek").set_enabled(true)

func _exit():
	boid.get_node("Seek").set_enabled(false)
	pass

func _think():
	if target.distance_to(boid.global_transform.origin) < 5:		
		# See: https://www.reddit.com/r/godot/comments/hu213d/class_was_found_in_global_scope_but_its_script/		
		# boid.get_node("StateMachine").change_state(AttackState.new())
		var DockedState = load("res://DockedState.gd")
		boid.get_node("StateMachine").change_state(DockedState.new())
		pass
		
func get_class():
	return "RetreatState"
	
func _ready():
	boid = get_parent()
	pass
