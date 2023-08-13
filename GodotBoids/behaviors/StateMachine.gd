class_name StateMachine extends Node

export var initial_state:NodePath
export var global_state_path:NodePath

var current_state:State
var global_state:State
var previous_state:State

var boid

func change_state(var new_state):
	print(str(boid) + "\t" + new_state.get_class())
	if current_state:
		current_state._exit()
		boid.call_deferred("remove_child", current_state);
	current_state = new_state
	if current_state:
		boid.add_child(current_state);
		current_state._enter()
	
func _ready():
	boid = get_parent()
	if initial_state:
		current_state = get_node(initial_state)
		current_state.call_deferred("_enter")
		# current_state._enter()
	if global_state_path:
		global_state = get_node(global_state_path)
		# Ready may not have been called!
		global_state.call_deferred("_enter")
		# current_state._enter()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DebugDraw.set_text(get_parent().get_name(), current_state.get_class() + " " + (global_state.get_class() if global_state else ""))
	
	if current_state:
		current_state._think()
	if global_state:
		global_state._think()
