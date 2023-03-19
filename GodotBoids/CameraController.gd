extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("..")
export var camera_boid_path:NodePath
onready var camera_boid = get_node(camera_boid_path) 

enum Mode { Free, Follow}

export var mode = Mode.Follow

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if mode == Mode.Follow:	
		camera.global_transform.origin = lerp(camera.global_transform.origin, camera_boid.global_transform.origin, delta * 5.0)
		var desired = camera.global_transform.basis.looking_at(camera_boid.global_transform.origin, Vector3.UP)
		camera.global_transform.basis = desired
		# camera.global_transform.basis.slerp(desired, delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	DebugDraw.set_text("Mode", mode)
	if Input.is_key_pressed(KEY_C):
		mode = (mode + 1) % 2
	pass
