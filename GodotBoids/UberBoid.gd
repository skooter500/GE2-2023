extends KinematicBody

export var mass = 1
export var force = Vector3.ZERO
export var acceleration = Vector3.ZERO
export var velocity = Vector3.ZERO
export var speed:float
export(float) var max_speed = 10.0

var behaviors = [] 
export var max_force = 10
export var banking = 0.1
export var damping = 0.1

func print_basis():
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0))
	DebugDraw.draw_line(transform.origin,  transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0))
	DebugDraw.set_text("transform.origin: ", transform.origin)
	DebugDraw.set_text("translation: ", translation)
	DebugDraw.set_text("rotation: ", rotation)
	DebugDraw.set_text("rotation_degrees: ", rotation_degrees)
	DebugDraw.set_text("transform.basis.x: ", transform.basis.x)
	DebugDraw.set_text("transform.basis.y: ", transform.basis.y)
	DebugDraw.set_text("transform.basis.z: ", transform.basis.z)

	DebugDraw.set_text("Vector3.FORWARD: ", Vector3.FORWARD)
	DebugDraw.set_text("Vector3.BACK: ", Vector3.BACK)
	DebugDraw.set_text("Vector3.UP: ", Vector3.UP)
	DebugDraw.set_text("Vector3.DOWN: ", Vector3.DOWN)

func seek_force(target: Vector3):	
	var toTarget = target - transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count():
		var child = get_child(i)
		if child.has_method("calculate"):
			behaviors.push_back(child)
			
func calculate():	
	# WPTRS	
	for i in behaviors.size():
		force = Vector3.ZERO
		force += behaviors[i].calculate() * behaviors[i].weight
		force = force.limit_length(max_force)
	return force

func _process(var delta):
	print_basis()
		
func _physics_process(var delta):
	force = calculate()
	acceleration = force / mass
	velocity += acceleration * delta
	speed = velocity.length()
	if speed > 0:
		velocity = velocity.limit_length(max_speed)
		
		move_and_slide(velocity)
		
		# Implement Banking as described:
		# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
		var tempUp = transform.basis.y.linear_interpolate(Vector3.UP + (acceleration * banking), delta * 5.0)
		look_at(global_transform.origin - velocity, Vector3.UP)
