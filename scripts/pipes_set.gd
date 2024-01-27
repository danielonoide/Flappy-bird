extends Node2D

class_name PipeSet

const MIN_PIPE_NUM = 2
const MAX_PIPE_NUM = 4

const MIN_SEPARATION = 100  #85 minimum
const MAX_SEPARATION = 400

const PIPES_SCENE = preload("res://scenes/pipes.tscn")

@export_range(MIN_PIPE_NUM, MAX_PIPE_NUM) var pipes_num : int = 3 
@export_range(MIN_SEPARATION, MAX_SEPARATION) var separation: int = 100

const SEPARATION_OFFSET = 180
const INITIAL_POSITION_X = 120  #53 minimum
const FINAL_POSITION_X = 1821
const MIN_HEIGHT = 730
const MAX_HEIGHT = 345

const MIN_PIPE_SEPARATION = 120
const MAX_PIPE_SEPARATION = 0

const INITIAL_SPEED = 200
const MAX_SPEED = 600
const SPEED_INCREASE = 10


func _ready():
	SignalManager.pipe_passed.connect(_on_pipe_passed)
	SignalManager.player_death.connect(_on_player_death)
	
	var random_generator = RandomNumberGenerator.new()
	var x = INITIAL_POSITION_X

	for i in range(pipes_num):
		var new_height = random_generator.randi_range(MAX_HEIGHT, MIN_HEIGHT)
		var new_position : Vector2 = Vector2(x, new_height)

		if new_position.x >= FINAL_POSITION_X:
			break

		var new_pipe_separation = random_generator.randi_range(MAX_PIPE_SEPARATION, MIN_PIPE_SEPARATION)
		var pipe_pair = PIPES_SCENE.instantiate()
		pipe_pair.separation = new_pipe_separation
		pipe_pair.position = new_position
		add_child(pipe_pair)
		Global.last_pipe_pos = new_position

		x = x+separation+SEPARATION_OFFSET
			
		
func _physics_process(delta):
	position.x = position.x + Vector2.LEFT.x * Global.pipes_speed * delta

func _on_pipe_passed():
	#print("GLobal pipes speed: ", Global.pipes_speed)
	Global.pipes_speed += SPEED_INCREASE if Global.pipes_speed <= MAX_SPEED else 0

func _on_player_death():
	Global.pipes_speed = INITIAL_SPEED
	
