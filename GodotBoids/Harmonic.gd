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


func _on_HSlider_value_changed(value):
	distance = value
	pass # Replace with function body.


func _on_HSlider2_value_changed(value):
	radius =  value
	pass # Replace with function body.


func _on_HSlider4_value_changed(value):
	frequency = range_lerp(value, 0, 100, 0,2)
	pass # Replace with function body.


func _on_HSlider3_value_changed(value):
	amplitude = range_lerp(value, 0, 100, 0,180)	
	pass # Replace with function body.


func _on_HSlider5_value_changed(value):
	weight = range_lerp(value, 0, 100, 0, 10)
	pass # Replace with function body.
