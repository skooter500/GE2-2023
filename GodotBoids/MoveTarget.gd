extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var interval = 3
export var radius = 30

func moveTarget():
	var newTarget = Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))
	$Tween.interpolate_property($"."
		, "translation"
		, $".".transform.origin
		, newTarget
		, 7
		, Tween.TRANS_BACK
		, Tween.EASE_IN_OUT
		)
	$Tween.start();


# Called when the node enters the scene tree for the first time.
func _ready():
	moveTarget()
#	while true:
#		yield(get_tree().create_timer(interval), "timeout")
#		translation = Vector3(rand_range(-radius, radius), 0, rand_range(-radius, radius))
#		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Timer_timeout():
	moveTarget()
