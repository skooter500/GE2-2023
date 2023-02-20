extends Camera


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var sensitivity = 0.1

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(- event.relative.x * sensitivity))
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
