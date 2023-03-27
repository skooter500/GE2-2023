extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var obstacle_scene:PackedScene

export var count = 5

export var radius = 100
export var bubble_radius = 10 

onready var cent = $"../Center"

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in count:
		var o = obstacle_scene.instance()		
		var pos = Utils.random_point_in_unit_sphere() * radius
		o.global_transform.origin = pos
		o.global_transform.basis = o.global_transform.basis.scaled(Utils.random_point_in_unit_sphere() * bubble_radius)
		add_child(o)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
