class_name PlayerSteering extends SteeringBehavior

var force:Vector3

func draw_gizmos():
	DebugDraw.draw_arrow_line(boid.global_transform.origin, boid.global_transform.origin + force * 10 * weight, Color.yellow, 0.1)

func _ready():
	boid = get_parent()
	
func calculate():
	var projectedRight = boid.global_transform.basis.x
	projectedRight.y = 0
	projectedRight = projectedRight.normalized()
	var turn = - Input.get_axis("turn_left", "turn_right")
	var move = - Input.get_axis("move_forward", "move_back")
	var upanddown = Input.get_axis("move_up", "move_down")
	var force:Vector3
	force += move * boid.global_transform.basis.z
	force += turn * projectedRight
	force += Vector3.UP * upanddown
	return force	
