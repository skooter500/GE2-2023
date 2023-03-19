extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var harmonic = get_node("../creature/boid/Harmonic")
onready var direction = get_node("GridContainer2/OptionButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	direction.add_item("Horizontal")
	direction.add_item("Vertical")
	
	pass
	# $distance.value = harmonic.distance
	# $radius.value = harmonic.radius
	# $amplitude.value = harmonic.amplitude
	# $Frequency.value = harmonic.frequency
	# $weight.value = harmonic.weight
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_distance_value_changed(value):
	harmonic.distance = value
	pass # Replace with function body.


func _on_radius_value_changed(value):
	harmonic.radius = value
	pass # Replace with function body.


func _on_amplitude_value_changed(value):
	harmonic.amplitude = value
	pass # Replace with function body.


func _on_Frequency_value_changed(value):
	harmonic.frequency = value
	pass # Replace with function body.


func _on_weight_value_changed(value):
	harmonic.weight = value
	pass # Replace with function body.


func _on_OptionButton_item_selected(index):
	harmonic.axis = index
	pass # Replace with function body.
