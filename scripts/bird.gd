extends CharacterBody2D

class_name Bird

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
const MAX_ROTATION = 45
const MIN_ROTATION = -45
const ROTATION_MOV = 50

func _process(delta):
	if rotation_degrees<MAX_ROTATION:
		rotation_degrees+=ROTATION_MOV * delta
	

func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
	velocity.y += gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("jump"): # and is_on_floor():
		#velocity.y = JUMP_VELOCITY
		#rotation_degrees = MIN_ROTATION
	
	move_and_slide()
	

func _unhandled_input(event):
	#if event is InputEventMouseButton and event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.is_pressed():
		#velocity.y = JUMP_VELOCITY
		#rotation_degrees = MIN_ROTATION
		
		
	if event.is_action_pressed("jump"):
		velocity.y = JUMP_VELOCITY
		rotation_degrees = MIN_ROTATION
		


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
""" 	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) """

