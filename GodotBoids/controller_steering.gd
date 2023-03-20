extends SteeringBehavior

export var power = 10
	
func _ready():
	boid = get_parent()
	
func calculate():
	var projectedRight = boid.global_transform.basis.x
	projectedRight.y = 0
	projectedRight = projectedRight.normalized()
	var turn = - Input.get_axis("turn_left", "turn_right")
	var move = - Input.get_axis("move_forward", "move_back")
	var force:Vector3
	force += move * boid.global_transform.basis.z * power
	force += turn * projectedRight * power
	return force	
