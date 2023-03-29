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

export var draw_gizmos = true


export var pause = false

func _input(event):
	if event is InputEventKey and event.scancode == KEY_P and event.pressed:
			pause = ! pause
	print(event)

func draw_gizmos():
	DebugDraw.draw_arrow_line(transform.origin,  transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1), 0.1)
	DebugDraw.draw_arrow_line(transform.origin,  transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0), 0.1)
	DebugDraw.draw_arrow_line(transform.origin,  transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0), 0.1)
	DebugDraw.draw_arrow_line(transform.origin,  transform.origin + force , Color(1, 1, 0), 0.1)
	DebugDraw.set_text("Force mag", force.length())

func seek_force(target: Vector3):	
	var toTarget = target - transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - velocity
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - transform.origin
	var dist = toTarget.length()
	
	if dist == 0:
		return Vector3.ZERO
	
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
			child.set_process(child.enabled) 
	# enable_all(false)
	
func enable_all(enabled):
	for i in behaviors.size():
		behaviors[i].enabled = enabled

func calculate():	
	var force_acc = Vector3.ZERO
	var behaviors_active = ""
	for i in behaviors.size():
		if behaviors[i].enabled:
			var f = behaviors[i].calculate() * behaviors[i].weight
			if is_nan(f.x) or is_nan(f.y) or is_nan(f.z):
				print(behaviors[i] + " is NAN")
				f = Vector3.ZERO
			behaviors_active += behaviors[i].name + ": " + str(round(f.length())) + " "
			force_acc += f 
			if force_acc.length() > max_force:
				force_acc = force_acc.limit_length(max_force)
				behaviors_active += " Limiting force"
				break
	DebugDraw.set_text(behaviors_active)
	return force_acc

func _process(var delta):
	if draw_gizmos:
		draw_gizmos()
		
func _physics_process(var delta):
	# lerp in the new forces
	force = lerp(force, calculate(), delta)
	acceleration = force / mass
	
	if not pause:
		velocity += acceleration * delta
		speed = velocity.length()
		if speed > 0:		
			velocity = velocity.limit_length(max_speed)
			
			# Damping
			velocity -= velocity * delta * damping
			
			
			move_and_slide(velocity)
			
			# Implement Banking as described:
			# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
			var temp_up = global_transform.basis.y.linear_interpolate(Vector3.UP + (acceleration * banking), delta * 5.0)
			# look_at(global_transform.origin - velocity, temp_up)
