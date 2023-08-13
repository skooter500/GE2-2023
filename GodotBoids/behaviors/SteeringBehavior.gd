class_name SteeringBehavior extends Node

export var weight = 1.0
export var draw_gizmos = true

var boid

export var enabled = true setget set_enabled, is_enabled

func set_enabled(var e):
	enabled = e 
	set_process(enabled)

func is_enabled():
	return enabled
	
func draw_gizmos():
	pass
	
func _process(delta):	
	if draw_gizmos and enabled:
		draw_gizmos()
