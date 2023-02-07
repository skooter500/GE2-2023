extends KinematicBody


# Declare member variables here. Examples:
export var speed = 10.0
# var a = 2
# var b = "text"

func destroy():
	get_parent().remove_child(self)


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var v  = speed * transform.basis.z
	var collision = move_and_collide(v * delta)		
	if collision:
		print("Collision!!!!")


func _on_Timer_timeout():
	print("Timer timed out")
	destroy()
	pass # Replace with function body.
