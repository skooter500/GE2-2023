extends KinematicBody


# Declare member variables here. Examples:
export var speed = 10.0
# var a = 2
# var b = "text"

var noise:OpenSimplexNoise = OpenSimplexNoise.new()

func _ready():
	noise.seed = randi()
	noise.octaves = 4
	noise.period = 20.0
	noise.persistence = 0.8

func destroy():
	get_parent().remove_child(self)
	
	
var t = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var v  = speed * transform.basis.z * delta
		
	
	# Add a noise 
	var n = Vector3(noise.get_noise_1d(t), noise.get_noise_1d(t + 1),  noise.get_noise_1d(t + 2))
	n = global_transform.basis.xform(n)
	
	# I think this should return true when a collision happens, but it doesnt
	# var collision = move_and_collide(v * delta)		
	translate(v + n)
	# look_at(global_transform.origin - v, global_transform.basis.y)
	# if collision:
	# 	print("Collision!!!!")
	t += delta

func _on_Timer_timeout():
	destroy()
	pass # Replace with function body.
