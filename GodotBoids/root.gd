extends Spatial

# Declare member variables here. Examples:
# var a = 2
# var b = "text"q

# Called when the node enters the scene tree for the first time.
func _ready():
	OS.set_current_screen(0)
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	# print(OS.get_screen_count())
	OS.set_window_position(screen_size*0.5 - window_size*0.5) 	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
