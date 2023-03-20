extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var weight:float = 1
export var radius:float

export var draw_gizmos:bool = true

var boid

func draw_gizmos():
	pass
	
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
