extends KinematicBody


# Declare member variables here. Examples:
export var speed = 10.0
# var a = 2
# var b = "text"

var forward

var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8
	
	get_node("AudioStreamPlayer3D").pitch_scale = rand_range(0.5, 1.0)

func destroy():
	get_parent().remove_child(self)
	
var t = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if not forward:
		forward = global_transform.basis.z
	
	var v  = speed * forward * delta		
	
	
	# Add a noise 
	var n = Vector3(noise.get_noise_1d(t), noise.get_noise_1d(t + 100),  1)
	n = global_transform.basis.xform(n) * 0.05
	# DebugDraw.draw_arrow_line(Vector3.ZERO, n * 50, Color.red, 0.1)
	# I think this should return true when a collision happens, but it doesnt
	v += n
	var collision = move_and_collide(v)	
	# 
	# global_transform.origin += v
	
	# look_at(global_transform.origin - v, global_transform.basis.y)
	t += delta * 10

func _on_Timer_timeout():
	destroy()
	pass # Replace with function body.
