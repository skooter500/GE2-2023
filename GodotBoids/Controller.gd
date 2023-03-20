extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"$
onready var harmonic = get_node("../creature/boid/Harmonic")
onready var direction = get_node("GridContainer2/OptionButton")

# Called when the node enters the scene tree for the first time.
func _ready():
	direction.add_item("Horizontal")
	direction.add_item("Vertical")
	$GridContainer2/distance.value = harmonic.distance
	$GridContainer2/distance.value = harmonic.distance
	$GridContainer2/radius.value = harmonic.radius
	$GridContainer2/amplitude.value = harmonic.amplitude
	$GridContainer2/Frequency.value = harmonic.frequency
	$GridContainer2/weight.value = harmonic.weight
	
	$GridContainer2/damping.value = $"../creature/boid/spineanimator".damping
	$GridContainer2/angularDamping.value = $"../creature/boid/spineanimator".damping
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


func _on_damping_value_changed(value):
	$"../creature/boid/spineanimator".damping = value	
	pass # Replace with function body.


func _on_angularDamping_value_changed(value):
	$"../creature/boid/spineanimator".angular_damping = value
	pass # Replace with function body.
