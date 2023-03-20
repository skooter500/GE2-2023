extends SteeringBehavior


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var target_node:NodePath
onready var target = get_node(target_node)

func draw_gizmos():
	DebugDraw.draw_line(boid.global_transform.origin, target.global_transform.origin)

func calculate():	
	return boid.seek_force(target.global_transform.origin)

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.

func _process(delta):	
	if draw_gizmos:
		draw_gizmos()
