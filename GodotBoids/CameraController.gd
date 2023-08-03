extends Node

# var a = 2
# var b = "text"

onready var player = get_node("../../")
export var boid_player_path:NodePath
var boid_player 

export var boid_path:NodePath
var boid

enum Mode { 	Free, Follow, Boid}

export var mode = Mode.Free

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_node(boid_path)
	boid_player = get_node(boid_player_path)
	match mode:
		Mode.Free:
			player.can_move = true
		Mode.Follow:
			player.can_move = false
			boid_player.global_transform.origin = player.transform.origin
			call_deferred("calculate_offset")

func calculate_offset():
	boid_player.get_node("OffsetPursue").calculate_offset()
	
func _input(event):
	if event is InputEventKey and event.scancode == KEY_C and event.pressed:
		match mode:
			Mode.Free:
				player.can_move = false
				mode = Mode.Follow
				boid_player.transform.origin = player.transform.origin
				boid_player.get_node("OffsetPursue").calculate_offset()
			Mode.Follow:
				player.can_move = true
				mode = Mode.Free

	if event is InputEventKey and event.scancode == KEY_B and event.pressed:
		match mode:
			Mode.Follow:
				player.can_move = false
				boid.find_node("MeshInstance").set_visible(false)
				mode = Mode.Free				
			Mode.Free:
				player.can_move = false
				boid.find_node("MeshInstance").set_visible(false)
				mode = Mode.Boid
			Mode.Boid:
				boid.find_node("MeshInstance").set_visible(true)				
				player.can_move = true
				mode = Mode.Free
						
func _physics_process(delta):
	match mode:
		Mode.Follow:	
			player.global_transform.origin = lerp(player.global_transform.origin, boid_player.global_transform.origin, delta * 10.0)
			var desired = player.global_transform.looking_at(boid.global_transform.origin, Vector3.UP)		
			player.global_transform.basis = player.global_transform.basis.slerp(desired.basis, delta * 2).orthonormalized()
		Mode.Boid:
			player.global_transform.origin = lerp(player.global_transform.origin, boid.global_transform.origin, delta * 5.0)
			var desired = player.global_transform.looking_at(boid.global_transform.origin + boid.global_transform.basis.z , Vector3.UP)
			player.global_transform.basis = player.global_transform.basis.slerp(desired.basis, delta * 5).orthonormalized()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# DebugDraw.set_text("mode", str(mode))
	pass
