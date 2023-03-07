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

# Instantiate
var noise:OpenSimplexNoise = OpenSimplexNoise.new()

# Configure

	

func _ready():
	boid = get_parent()
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
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
	var n  = noise.get_noise_1d(theta)
	DebugDraw.set_text("Noise: " + str(n))
	var angle = deg2rad(n * amplitude)
	
	var delta = get_process_delta_time()

	var rot = boid.transform.basis.get_euler()
	rot.x = 0

	if axis == Axis.Horizontal:
		target.x = sin(angle)
		target.z =  cos(angle)
		rot.z = 0
	else:
		target.y = sin(angle)
		target.z = cos(angle)
	
	target *= radius

	var localtarget = target + (Vector3.BACK * distance)
	
	var projected = Basis(rot)
	
	worldTarget = boid.global_transform.origin + (projected * localtarget)	
	theta += frequency * delta * PI * 2.0

	return boid.seek_force(worldTarget)
