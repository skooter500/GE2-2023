extends KinematicBody

export var mass = 1
export var force = Vector3.ZERO
export var acceleration = Vector3.ZERO
export var velocity = Vector3.ZERO
export var speed:float
export(float) var max_speed = 10.0

export var behaviors = [] 
export var max_force = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.2
	
func calculate():	
	# WPTRS	
	for i in behaviors.size():
		force = Vector3.ZERO
		force += behaviors[i].calculate() * behaviors[i].weight
		force = force.limit_length(max_force)
	return force

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
		look_at(global_transform.origin - velocity, tempUp)
		
