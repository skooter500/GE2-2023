class_name DockedState extends State

onready var attacker = get_node("../../Attacker")

var boid

func _enter():
	pass
	
func _think():
	var to_attacker = boid.global_transform.origin.distance_to(attacker.global_transform.origin)
	if to_attacker < 100:
		boid.get_node("StateMachine").change_state(LaunchState.new())

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
