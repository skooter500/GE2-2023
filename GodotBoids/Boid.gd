class_name Boid extends KinematicBody

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

var count_neighbors = false
var neighbors = [] 

var school = null
var new_force = Vector3.ZERO
var should_calculate = false

func count_neighbors_partitioned():
	neighbors.clear()

	# var cells_around = 1
	var my_cell = school.position_to_cell(transform.origin)
		
	if draw_gizmos:
		var a = school.cell_to_position(my_cell)
		var b = a + Vector3(school.cell_size, school.cell_size, school.cell_size)
		DebugDraw.draw_aabb_ab(a, b, Color.cyan)
						
	# Check center cell first!
	for slice in [0, -1, 1]:
		for row in [0, -1, 1]:
			for col in [0, -1, 1]:
				var pos = global_transform.origin + Vector3(col * school.cell_size, row * school.cell_size, slice * school.cell_size)
				var key = school.position_to_cell(pos)
				
				if draw_gizmos:
					var a = school.cell_to_position(key)
					var b = a + Vector3(school.cell_size, school.cell_size, school.cell_size)
					DebugDraw.draw_aabb_ab(a, b, Color.cyan)
				
				if school.cells.has(key):
					var cell = school.cells[key]
					# print(key)
					for boid in cell:
						if draw_gizmos:
							if boid != self:
								DebugDraw.draw_box(boid.global_transform.origin, Vector3(3, 3, 3), Color.darkgoldenrod, true)
						if boid != self and boid.global_transform.origin.distance_to(global_transform.origin) < school.neighbor_distance:
							neighbors.push_back(boid)
							if neighbors.size() == school.max_neighbors:
								return neighbors.size()					
	return neighbors.size()
	
func count_neighbors():
	neighbors.clear()
	for i in school.boids.size():
		var boid = school.boids[i]
		if boid != self and global_transform.origin.distance_to(boid.global_transform.origin) < school.neighbor_distance:
			neighbors.push_back(boid)
			if neighbors.size() == school.max_neighbors:
				break
	return neighbors.size()

func _input(event):
	if event is InputEventKey and event.scancode == KEY_P and event.pressed:
		pause = ! pause
		
func set_enabled(var behavior, var enabled):
	behavior.enabled = enabled
	behavior.set_process(enabled)


func draw_gizmos():
	DebugDraw.draw_arrow_line(global_transform.origin,  global_transform.origin + transform.basis.z * 10.0 , Color(0, 0, 1), 0.1)
	DebugDraw.draw_arrow_line(global_transform.origin,  global_transform.origin + transform.basis.x * 10.0 , Color(1, 0, 0), 0.1)
	DebugDraw.draw_arrow_line(global_transform.origin,  global_transform.origin + transform.basis.y * 10.0 , Color(0, 1, 0), 0.1)
	DebugDraw.draw_arrow_line(global_transform.origin,  global_transform.origin + force, Color(1, 1, 0), 0.1)
	
	if school and count_neighbors:
		DebugDraw.draw_sphere(global_transform.origin, school.neighbor_distance, Color.webpurple)
		for neighbor in neighbors:
			DebugDraw.draw_sphere(neighbor.global_transform.origin, 3, Color.webpurple)
			
func seek_force(target: Vector3):	
	var toTarget = target - global_transform.origin
	toTarget = toTarget.normalized()
	var desired = toTarget * max_speed
	return desired - velocity
	
func arrive_force(target:Vector3, slowingDistance:float):
	var toTarget = target - global_transform.origin
	var dist = toTarget.length()
	
	if dist < 2:
		return Vector3.ZERO
	
	var ramped = (dist / slowingDistance) * max_speed
	var clamped = min(max_speed, ramped)
	var desired = (toTarget * clamped) / dist 
	return desired - velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	# Check for a variable
	if "partition" in get_parent():
		school = get_parent()
	
	for i in get_child_count():
		var child = get_child(i)
		if child.has_method("calculate"):
			behaviors.push_back(child)
			child.set_process(child.enabled) 
	# enable_all(false)
	
func set_enabled_all(enabled):
	for i in behaviors.size():
		behaviors[i].enabled = enabled
		
func update_weights(weights):
	for behavior in weights:
		var b = get_node(behavior)
		if b: 
			b.weight = weights[behavior]

func calculate():
	var force_acc = Vector3.ZERO	
	var behaviors_active = ""
	for i in behaviors.size():
		if behaviors[i].enabled:
			var f = behaviors[i].calculate() * behaviors[i].weight
			if is_nan(f.x) or is_nan(f.y) or is_nan(f.z):
				print(str(behaviors[i]) + " is NAN")
				f = Vector3.ZERO
			behaviors_active += behaviors[i].name + ": " + str(round(f.length())) + " "
			force_acc += f 
			if force_acc.length() > max_force:
				force_acc = force_acc.limit_length(max_force)
				behaviors_active += " Limiting force"
				break
	if draw_gizmos:
		DebugDraw.set_text(str(self) + " " + behaviors_active)
	return force_acc


func _process(var delta):
	should_calculate = true
	if draw_gizmos:
		draw_gizmos()
	if school and count_neighbors:
		if school.partition:
			count_neighbors_partitioned()
		else:
			count_neighbors()
			
func _physics_process(var delta):
	# pause = false
	# lerp in the new forces
	if should_calculate:
		new_force = calculate()
		should_calculate = false		
	force = lerp(force, new_force, delta)
	if ! pause:
		acceleration = force / mass
		velocity += acceleration * delta
		speed = velocity.length()
		if speed > 0:		
			if max_speed == 0:
				print("max_speed is 0")
			velocity = velocity.limit_length(max_speed)
			
			# Damping
			velocity -= velocity * delta * damping
			
			move_and_slide(velocity)
			
			# Implement Banking as described:
			# https://www.cs.toronto.edu/~dt/siggraph97-course/cwr87/
			var temp_up = global_transform.basis.y.linear_interpolate(Vector3.UP + (acceleration * banking), delta * 5.0)
			look_at(global_transform.origin - velocity.normalized(), temp_up)
