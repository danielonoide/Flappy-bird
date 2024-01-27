extends CanvasLayer

@onready var label : Label = $Label
@onready var max_points_label : Label = $MaxPointsLabel

const DYING_TEXT = "You died"

var paused : bool = false

func _ready():
	SignalManager.player_death.connect(_on_player_death)


func _input(event):	
	if event.is_action_pressed(("pause")):
		change_pause_state(!paused)


func change_pause_state(state : bool):
	if label.text == DYING_TEXT:
		return
	
	paused = state
	visible = state
	get_tree().paused = state

	if state: 
		max_points_label.text = "Max points: " + str(Global.max_points)


func _on_restart_btn_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_exit_btn_pressed():
	get_tree().quit()


func _on_player_death():
	change_pause_state(true)
	label.text = DYING_TEXT


func _on_pause_button_pressed():
	change_pause_state(!paused)
