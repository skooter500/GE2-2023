class_name SteeringBehavior extends Node

export var weight = 1.0
export var enabled = true
export var draw_gizmos = true

var boid

func set_enabled(var enabled):
	enabled = false
	set_process(enabled)
