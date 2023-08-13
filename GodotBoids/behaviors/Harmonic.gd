tool class_name Harmonic extends SteeringBehavior

export var frequency = 0.3
export var radius = 10.0

export var amplitude = 80
export var distance = 5

enum Axis { Horizontal, Vertical}
export var axis = Axis.Horizontal
var target:Vector3
var worldTarget:Vector3

var theta
	
func _ready():
	boid = get_parent()
	theta = rand_range(0, PI * 2.0)
	
func _process(delta):
	if draw_gizmos:
		boid = get_parent()
		var cent = boid.global_transform.xform(Vector3.BACK * distance)
		DebugDraw.draw_sphere(cent, radius, Color.hotpink)
		DebugDraw.draw_line(boid.global_transform.origin, cent, Color.hotpink)
		DebugDraw.draw_arrow_line(cent, worldTarget, Color.hotpink, 0.1)
			
func calculate():		
	var n  = sin(theta)
	var angle = deg2rad(n * amplitude)
	
	var delta = get_process_delta_time()

	var rot = boid.global_transform.basis.get_euler()
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
