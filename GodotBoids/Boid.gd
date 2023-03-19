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
	DebugDraw.draw_line(transform.origin,  transform.origin + force * 10.0 , Color(1, 1, 0))
	DebugDraw.set_text("transform.origin", transform.origin)
	DebugDraw.set_text("translation", translation)
	DebugDraw.set_text("rotation", rotation)
	DebugDraw.set_text("rotation_degrees", rotation_degrees)
	DebugDraw.set_text("transform.basis.x", transform.basis.x)
	DebugDraw.set_text("transform.basis.y", transform.basis.y)
	DebugDraw.set_text("transform.basis.z", transform.basis.z)

	DebugDraw.set_text("Vector3.FORWARD", Vector3.FORWARD)
	DebugDraw.set_text("Vector3.BACK", Vector3.BACK)
	DebugDraw.set_text("Vector3.UP", Vector3.UP)
	DebugDraw.set_text("Vector3.DOWN", Vector3.DOWN)

func seek_force(target: Vector3):	
	var toTarget = target - transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - velocity
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - transform.origin
	var dist = toTarget.length()
	
	if dist == 0:
		return Vector3.ZERO;
	
	var ramped = (dist / slowingDistance) * max_speed
	var clamped = min(max_speed, ramped)
	var desired = (toTarget * clamped) / dist 
	return desired - velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in get_child_count():
		var child = get_child(i)
		if child.has_method("calculate"):
			behaviors.push_back(child)
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	OS.set_window_position(screen_size*0.5 - window_size*0.5)

func calculate():	
	# 
	force = Vector3.ZERO
	for i in behaviors.size():
		var f = behaviors[i].calculate();
		if is_nan(f.x) or is_nan(f.y) or is_nan(f.z):
			print(f)
		force += f * behaviors[i].weight
		if force.length() > max_force:
			force = force.limit_length(max_force)
			break
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
		
		#move_and_slide(velocity)
		
		# Implement Banking as described:
		# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
		var tempUp = transform.basis.y.linear_interpolate(Vector3.UP + (acceleration * banking), delta * 5.0)
		# look_at(global_transform.origin - velocity, Vector3.UP)
