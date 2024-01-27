extends Node

const USER_DATA_PATH = "user://points.save"
var max_points = 0
var pipes_speed = 200

var last_pipe_pos : Vector2 = Vector2.ZERO

func _ready():
	if FileAccess.file_exists(USER_DATA_PATH):
		load_points()
		
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	#var window_size = DisplayServer.window_get_size()
	#DisplayServer.window_set_size(window_size/1.1)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)



func load_points():
	var file = FileAccess.open(USER_DATA_PATH, FileAccess.READ)
	var file_text = file.get_line()
	max_points = int(file_text)
	file.close()
	

func save_points():
	var file = FileAccess.open(USER_DATA_PATH, FileAccess.WRITE)
	file.store_line(str(max_points))
	file.close()

