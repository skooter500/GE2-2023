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
	match mode:
		Mode.Free:
			camera.move = true
		Mode.Follow:
			camera.move = false
			boid_camera.global_transform.origin = camera.transform.origin
			call_deferred("calculate_offset")

func calculate_offset():
	boid_camera.get_node("OffsetPursue").calculate_offset()
	
func _input(event):
	if event is InputEventKey and event.scancode == KEY_C and event.pressed:
		match mode:
			Mode.Free:
				camera.move = false
				mode = Mode.Follow
				boid_camera.transform.origin = camera.transform.origin
				boid_camera.get_node("OffsetPursue").calculate_offset()
			Mode.Follow:
				camera.move = true
				mode = Mode.Free

	if event is InputEventKey and event.scancode == KEY_B and event.pressed:
		match mode:
			Mode.Follow, Mode.Free:
				camera.move = false
				boid.get_node("MeshInstance").set_visible(false)
				mode = Mode.Boid
			Mode.Boid:
				boid.get_node("MeshInstance").set_visible(true)				
				camera.move = true
				mode = Mode.Free
						
func _physics_process(delta):
	match mode:
		Mode.Follow:	
			camera.global_transform.origin = lerp(camera.global_transform.origin, boid_camera.global_transform.origin, delta * 10.0)
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
