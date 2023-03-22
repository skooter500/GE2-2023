extends SteeringBehavior

export var radius:float = 100

export var center_path:NodePath
onready var center = get_node(center_path)  

func draw_gizmos():
	DebugDraw.draw_sphere(center.global_transform.origin, radius, Color.beige)
	pass

func calculate():
	var to_center = center.global_transform.origin - boid.global_transform.origin
	var power = max(to_center.length() - radius, 0)
	return to_center.limit_length(power)
	 
func _process(delta):
	if draw_gizmos:
		draw_gizmos()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	# boid.transform.rotated()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
