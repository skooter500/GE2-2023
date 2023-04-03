extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("..")
export var boid_camera_path:NodePath
onready var boid_camera = get_node(boid_camera_path) 

export var boid_path:NodePath
onready var boid = get_node(boid_path) 

enum Mode { Free, Follow, Boid}

export var mode = Mode.Free

# Called when the node enters the scene tree for the first time.
func _ready():
	camera.move = true
	pass # Replace with function body.
	
func _input(event):
	if event is InputEventKey and event.scancode == KEY_O and event.pressed:
		match mode:
			Mode.Free:
				camera.move = false
				mode = Mode.Follow
			Mode.Follow, Mode.Boid:
				camera.move = true
				mode = Mode.Free
			
	if event is InputEventKey and event.scancode == KEY_C and event.pressed:
		match mode:
			Mode.Free:
				camera.move = false
				mode = Mode.Follow
			Mode.Follow:
				camera.move = false
				mode = Mode.Boid
			Mode.Boid:
				camera.move = true
				mode = Mode.Free

func _physics_process(delta):
	match mode:
		Mode.Follow:	
			camera.global_transform.origin = lerp(camera.global_transform.origin, boid_camera.global_transform.origin, delta * 5.0)
			var desired = camera.global_transform.looking_at(boid.global_transform.origin, Vector3.UP)		
			camera.global_transform.basis = camera.global_transform.basis.slerp(desired.basis, delta * 2).orthonormalized()
		Mode.Boid:
			camera.global_transform.origin = lerp(camera.global_transform.origin, boid.global_transform.origin, delta * 5.0)
			var desired = camera.global_transform.looking_at(boid.global_transform.origin + boid.global_transform.basis.z , Vector3.UP)
			camera.global_transform.basis = camera.global_transform.basis.slerp(desired.basis, delta * 5).orthonormalized()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# DebugDraw.set_text("mode", str(mode))
	pass
