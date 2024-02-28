extends CanvasLayer

@onready var label : Label = $Label
@onready var max_points_label : Label = $MaxPointsLabel
@onready var counter_label : Label = $"../CounterLabel"
@onready var pause_button : TextureButton = $"../PauseButton"
var pause_disabled = false

const DYING_TEXT = "You died"

var paused : bool = false

func _ready():
	SignalManager.player_death.connect(_on_player_death)


func _input(event):	
	if event.is_action_pressed(("pause")) and !pause_disabled:
		change_pause_state(!paused)


func change_pause_state(state : bool):
	if label.text == DYING_TEXT:
		return
	
	paused = state
	visible = state
	pause_disabled = true
	pause_button.disabled = true
	
	if !paused:
		counter_label.visible = true
		for i in range(3, 0, -1): #empieza en 3, termina en 1 (es exclusive) y disminuye en -1
			counter_label.text = str(i)
			await get_tree().create_timer(1).timeout
		
		counter_label.visible = false
	
	pause_button.disabled = false
	pause_disabled = false
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
