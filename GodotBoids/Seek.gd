class_name Seek extends SteeringBehavior

export var target_path:NodePath
var target
var world_target:Vector3

func draw_gizmos():
	DebugDraw.draw_sphere(target.global_transform.origin, 3, Color.aqua)
	DebugDraw.draw_line(boid.global_transform.origin, target.global_transform.origin, Color.aqua)

func calculate():
	world_target = target.global_transform.origin
	return boid.seek_force(world_target)


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()
	if target_path:
		target = get_node(target_path)

