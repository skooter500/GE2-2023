extends KinematicBody

export var speed = 10.0
export var rotSpeed = 5.0

export (PackedScene) var bulletPrefab


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _drawGizmos():
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0))
	DebugDraw.set_text("transform.origin: ", transform.origin)
	DebugDraw.set_text("translation: ", translation)
	DebugDraw.set_text("rotation: ", rotation)
	DebugDraw.set_text("rotation_degrees: ", rotation_degrees)
	DebugDraw.set_text("transform.basis.x: ", transform.basis.x)
	DebugDraw.set_text("transform.basis.y: ", transform.basis.y)
	DebugDraw.set_text("transform.basis.z: ", transform.basis.z)

	DebugDraw.set_text("Vector3.FORWARD: ", Vector3.FORWARD)
	DebugDraw.set_text("Vector3.BACK: ", Vector3.BACK)
	DebugDraw.set_text("Vector3.UP: ", Vector3.UP)
	DebugDraw.set_text("Vector3.DOWN: ", Vector3.DOWN)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event.is_action_pressed("ui_select"):
		var bullet = bulletPrefab.instance()
		$"..".add_child(bullet) 

		bullet.set_global_rotation($Turret/bulletSpawn.get_global_rotation())				
		bullet.set_global_translation($Turret/bulletSpawn.get_global_translation())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):		
	# rotate_y(0.1)
	var turn = Input.get_axis("turn_left", "turn_right")
	DebugDraw.set_text("turn: ", str(turn))
	
	if abs(turn) > 0:     
		# rotate()
		rotation.y -= rotSpeed * delta * turn
	
	# rotate_y(0.1)
	# rotate_x(0.1)
	var move = Input.get_axis("move_forward", "move_back")
	DebugDraw.set_text("move: ", str(move))

	
	if abs(move) > 0:     
		move_and_slide(- transform.basis.z * speed * move)		
		
	_drawGizmos()
	
	
	
	
