extends Spatial

export var custom_font : Font


func draw_gizmos():
	var size = 5000
	var sub_divisions = size / 100
	DebugDraw.draw_grid(Vector3.ZERO, Vector3.RIGHT* size, Vector3.BACK * size, Vector2(sub_divisions, sub_divisions), Color.aquamarine)
	# DebugDraw.draw_grid(Vector3.ZERO, Vector3.UP * size, Vector3.BACK * size, Vector2(sub_divisions, sub_divisions), Color.aquamarine)


func _ready():
	OS.set_current_screen(1)
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()
	
	OS.set_window_position(screen_size*0.5 - window_size*0.5) 	
	DebugDraw.text_custom_font = custom_font

func _process(delta):
	draw_gizmos()
	var g = _create_graph("FPS", true, false, DebugDraw.BlockPosition_LeftTop if Engine.editor_hint else DebugDraw.BlockPosition_RightTop, DebugDraw.GraphTextFlags_Current | DebugDraw.GraphTextFlags_Avarage | DebugDraw.GraphTextFlags_Max | DebugDraw.GraphTextFlags_Min, Vector2(200, 80), custom_font)
	# g.buffer_size = 300

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
			graph.frame_time_mode = false
	return graph
