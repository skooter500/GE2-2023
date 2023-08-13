class_name NoiseWander extends SteeringBehavior

export var frequency = 0.3
export var radius = 10.0

export var theta = 0
export var amplitude = 80
export var distance = 5

enum Axis { Horizontal, Vertical}

export var axis = Axis.Horizontal
var target:Vector3
var world_target:Vector3

# Instantiate
var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	boid = get_parent()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
func _process(delta):
	if draw_gizmos:
		var cent = boid.global_transform.xform(Vector3.BACK * distance)
		DebugDraw.draw_sphere(cent, radius, Color.hotpink)
		DebugDraw.draw_line(boid.global_transform.origin, cent, Color.hotpink)
		DebugDraw.draw_arrow_line(cent, world_target, Color.hotpink, 0.1)

func calculate():		
	var n  = noise.get_noise_1d(theta)
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
		target.y = sin(angle)
		target.z = cos(angle)
		target.x = 0
		
	target *= radius

	var local_target = target + (Vector3.BACK * distance)
	
	var projected = Basis(rot)
	
	world_target = boid.global_transform.origin + (projected * local_target)	
	theta += frequency * delta * PI * 2.0

	return boid.seek_force(world_target)
