extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var camera = get_node("..")
onready var cameraBoid = get_node("../../camera follower") 

enum Mode { Free, Follow}

export var mode = Mode.Free

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	if mode == Mode.Follow:
		camera.global_transform.origin = lerp(camera.global_transform.origin, cameraBoid.global_transform.origin, delta)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_key_pressed(KEY_C):
		mode = (mode + 1) % 2
	pass
