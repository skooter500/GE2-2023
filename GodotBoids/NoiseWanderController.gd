extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var noise_wander = get_node("../creature/boid/NoiseWander")
onready var octaves = get_node("octaves")


# Called when the node enters the scene tree for the first time.
func _ready():
	octaves.value = noise_wander.noise.octaves
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_octaves_value_changed(value):
	noise_wander.noise.octaves = value
	pass # Replace with function body.
