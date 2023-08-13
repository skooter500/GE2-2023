extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, String) var scenes

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _input(event):
	if event is InputEventKey and event.pressed and ! event.echo:
		if event.scancode == KEY_Q:
			get_tree().quit()
		var i = event.scancode - KEY_0
		if event.scancode >= KEY_0 and i >= 0 and i < scenes.size():			
			get_tree().change_scene(scenes[i])
