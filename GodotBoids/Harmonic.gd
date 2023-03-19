extends Node

export var frequency = 0.3
export var radius = 10.0

export var theta = 0
export var amplitude = 80
export var distance = 5

enum Axis { Horizontal, Vertical}

export var axis = Axis.Horizontal

export var weight = 1.0

export var drawGizmos = true

var boid
var target:Vector3
var worldTarget:Vector3
	

func _ready():
	boid = get_parent()
	
func _process(delta):
	if drawGizmos:
		var cent = boid.global_transform.xform(Vector3.BACK * distance)
		DebugDraw.draw_sphere(cent, radius, Color.deeppink)
		DebugDraw.draw_line(boid.global_transform.origin, cent, Color.deeppink)
		DebugDraw.draw_line(cent, worldTarget, Color.blueviolet)
	
		DebugDraw.draw_sphere(worldTarget, 1)	
		DebugDraw.set_text("Radius: " + str(radius))
		DebugDraw.set_text("Distance: " + str(distance))

func calculate():		
	var n  = sin(theta)
	var angle = deg2rad(n * amplitude)
	
	var delta = get_process_delta_time()

	var rot = boid.transform.basis.get_euler()
	rot.x = 0

	if axis == Axis.Horizontal:
		target.x = sin(angle)
		target.z =  cos(angle)
		target.y = 0
		rot.z = 0
	else:
		target.x = 0
		target.y = sin(angle)
		target.z = cos(angle)
	
	target *= radius

	var localtarget = target + (Vector3.BACK * distance)
	
	var projected = Basis(rot)
	
	worldTarget = boid.global_transform.origin + (projected * localtarget)	
	theta += frequency * delta * PI * 2.0
	
	var f = boid.seek_force(worldTarget)  

	return f
