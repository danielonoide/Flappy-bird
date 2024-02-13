extends Node2D

class_name World


const PIPE_SET_SCENE = preload("res://scenes/pipes_set.tscn")

const PIPE_SET_POS : Vector2 = Vector2(900, 0) #Vector2(1920, 0)

@onready var points_label : Label = $%Label
@onready var success_sound : AudioStreamPlayer = $AudioStreamPlayer

var points = 0

var pipe_separation_offset = 0  #ajuste para separar más mientras más velocidad
var master_bus = AudioServer.get_bus_index("Master")

func _ready():	
	SignalManager.pipe_passed.connect(add_point)
	SignalManager.player_death.connect(_on_player_death)
	$MuteBTN.button_pressed = AudioServer.is_bus_mute(master_bus)
	Global.last_pipe_pos = Vector2.ZERO	
	spawn_pipes()
	


func _on_pipe_spawner_area_entered(area):
	if area.name == "SpawnPipe":
		spawn_pipes()

func _on_pipe_remover_area_entered(area):
	if area.name == "SpawnPipe":
		area.get_parent().queue_free()


func _on_death_zone_body_entered(body):
	if body is Bird:
		SignalManager.player_death.emit()		
		

func spawn_pipes():
	
	#var pipes_num = random_generator.randi_range(PipeSet.MIN_PIPE_NUM, PipeSet.MAX_PIPE_NUM)
	#var pipes_num = 4
	pipe_separation_offset = (Global.pipes_speed - PipeSet.INITIAL_SPEED) / 2
	#print("PIPE SET separation: ", PipeSet.MIN_SEPARATION + pipe_separation_offset)
	var separation = randi_range(PipeSet.MIN_SEPARATION + pipe_separation_offset, PipeSet.MAX_SEPARATION)

	var pipe_set = PIPE_SET_SCENE.instantiate()
	var pipe_set_pos_x : float
	if Global.last_pipe_pos == Vector2.ZERO:
		pipe_set_pos_x = PIPE_SET_POS.x
	else:
		pipe_set_pos_x = randi_range(Global.last_pipe_pos.x+PipeSet.MIN_SEPARATION+pipe_separation_offset, Global.last_pipe_pos.x+PipeSet.MAX_SEPARATION) 
	
	pipe_set.position = Vector2(pipe_set_pos_x, 0)
	pipe_set.separation = separation
	#pipe_set.pipes_num = pipes_num

	call_deferred("add_child", pipe_set)
	"""
	Causa del Problema:
	El error se debe a que se está intentando agregar un nuevo nodo (instanciando una escena que contiene Area2D entre otros nodos) en respuesta a la señal _area_entered, 
	que se dispara durante el procesamiento de físicas o colisiones. Realizar operaciones de manipulación de nodos en este momento puede generar conflictos y errores en el motor de Godot.
	
	Razón de la Solución:
	La solución implica diferir la operación de agregar el nuevo nodo utilizando call_deferred(). Al hacerlo, se programará la adición del nuevo nodo para el próximo ciclo de procesamiento, 
	evitando conflictos con el procesamiento actual de físicas o colisiones.
	"""


func add_point():
	points = points + 1
	points_label.text = str(points)
	success_sound.play()


	
func _on_player_death():
	if points > Global.max_points:
		Global.max_points = points
		Global.save_points()


func _on_mute_btn_pressed():
	AudioServer.set_bus_mute(master_bus, not AudioServer.is_bus_mute(master_bus))
