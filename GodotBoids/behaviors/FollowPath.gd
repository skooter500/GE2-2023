class_name FollowPath extends SteeringBehavior

var pathIndex = 0

export var path_path:NodePath
onready var path:Path = get_node(path_path)
export var waypoint_seek_distance = 3

var target

func draw_gizmos():
	if target:
		DebugDraw.draw_sphere(target, waypoint_seek_distance, Color.cyan)

func calculate():
	target = path.global_transform.xform(path.get_curve().get_point_position(pathIndex))
	var dist = boid.global_transform.origin.distance_to(target)
	if dist < waypoint_seek_distance:
		pathIndex = (pathIndex + 1) % path.get_curve().get_point_count()
	return boid.seek_force(target)

# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
