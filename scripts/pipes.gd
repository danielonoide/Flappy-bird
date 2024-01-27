extends Node2D

class_name Pipes

@export_range(0, 120) var separation : int = 0  #120 es donde estan mas cerca

@onready var pipe1 : Area2D = $Pipe1
@onready var pipe2 : Area2D = $Pipe2


""" func _init(_separation:int = 0):
	separation = _separation
 """
func _ready():
	#print(pipe1.position.distance_to(pipe2.position))
	pipe1.body_entered.connect(_on_body_entered)
	pipe2.body_entered.connect(_on_body_entered)

	var half_separation = (float(separation)/2)

	pipe1.position.y-=half_separation
	pipe2.position.y+=half_separation



func _on_body_entered(body : Node2D):
	if body is Bird:
		SignalManager.player_death.emit()
	#print(body.name)


func _on_add_point_body_entered(body : Node2D):
	if body is Bird:
		SignalManager.pipe_passed.emit()
