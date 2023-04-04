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
func _process(delta):
	var g = _create_graph("FPS", true, false, DebugDraw.BlockPosition_LeftTop if Engine.editor_hint else DebugDraw.BlockPosition_RightTop, DebugDraw.GraphTextFlags_Current | DebugDraw.GraphTextFlags_Avarage | DebugDraw.GraphTextFlags_Max | DebugDraw.GraphTextFlags_Min, Vector2(200, 80), null)
	if g:
		g.buffer_size = 300
		var cfg = DebugDraw.get_graph_config("FPS")
		if cfg:
			cfg.frame_time_mode = false


func _create_graph(title, is_fps, show_title, pos, flags, size = Vector2(256, 60), font = null) -> DebugDraw.GraphParameters:
	var graph = DebugDraw.get_graph_config(title)
	if !graph:
		if is_fps:
			graph = DebugDraw.create_fps_graph(title)
		else:
			graph = DebugDraw.create_graph(title)
		
		if graph:
			graph.size = size
			graph.buffer_size = 50
			graph.position = pos
			graph.show_title = show_title
			graph.show_text_flags = flags
			graph.custom_font = font
	
	return graph
