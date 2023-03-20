extends SteeringBehavior

var pathIndex = 0
onready var path:Path = get_node("../../../Path")
export var waypointSeekDistance = 2

func calculate():
	var target = path.transform.xform(path.get_curve().get_point_position(pathIndex))
	var dist = boid.global_transform.origin.distance_to(target)
	if dist < waypointSeekDistance:
		pathIndex = (pathIndex + 1) % path.get_curve().get_point_count()
	return boid.seek_force(target)



# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
