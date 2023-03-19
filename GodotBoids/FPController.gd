extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var sensitivity = 0.1
export var speed:float = 1.0

var controlling = true

func _input(event):
	if event is InputEventMouseMotion and controlling:
		rotate(Vector3.DOWN, deg2rad(event.relative.x * sensitivity))
		rotate(transform.basis.x,deg2rad(- event.relative.y * sensitivity))
	if event.is_action_pressed("ui_cancel"):
		if controlling:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:			
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		controlling = ! controlling


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.

export var move:bool = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# look_at($"../../creature/boid".global_transform.origin, Vector3.UP)
	var turn = Input.get_axis("turn_left", "turn_right")
	
	if move:	
		if abs(turn) > 0:     
			# rotate()
			global_translate(global_transform.basis.x * speed * turn)
		
		# rotate_y(0.1)
		# rotate_x(0.1)
		var move = Input.get_axis("move_forward", "move_back")
		DebugDraw.set_text("move: ", str(move))

		if abs(move) > 0:     
			global_translate(global_transform.basis.z * speed * move)
		
		var upanddown = Input.get_axis("move_up", "move_down")
		DebugDraw.set_text("upanddown: ", str(upanddown))
		if abs(upanddown) > 0:     
			global_translate(- global_transform.basis.y * speed * upanddown)
