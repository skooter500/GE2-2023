extends MeshInstance


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

export var speed:float = 1.0 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# translate(Vector3.RIGHT * speed * delta)
	# translate_object_local(Vector3.RIGHT * speed * delta)
	
	transform.origin += Vector3.RIGHT * speed * delta
	global_transform.origin  += Vector3.RIGHT * speed * delta
	pass
