class_name Separation extends SteeringBehavior 


# Called when the node enters the scene tree for the first time.
func _ready():
	boid = get_parent()

func calculate():
	var force = Vector3.ZERO
	for i in boid.neighbours.size():
		var other = 
			{
				if (other != this.boid)
				{
					Vector3 toEntity = boid.position - other.position;
					steeringForce += (Vector3.Normalize(toEntity) / toEntity.magnitude);
				}
			}

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
