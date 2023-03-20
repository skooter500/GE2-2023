extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var weight:float = 1
export var radius:float

export var draw_gizmos:bool = true

export var centerPath:NodePath
onready var center = get_node(centerPath)  

onready var boid = get_parent()

func draw_gizmos():
	pass

func calculate():
	var dist = center.global_transform.origin.distance_to(boid.global_transform.origin)
	var howFar = max(dist - radius, 0)
	{
		
	}

func _process(delta):
	if draw_gizmos:
		draw_gizmos()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
