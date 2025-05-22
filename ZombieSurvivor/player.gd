extends CharacterBody2D

signal health_changed(current_health)
signal died

const SPEED = 300.0
const BULLET_SCENE = preload("res://bullet.tscn")

@export var health = 100
var facing_direction = Vector2.RIGHT

func _ready():
	add_to_group("player")
	health_changed.emit(health) # Emit initial health
	# collision_layer and collision_mask are set in Player.tscn

func _physics_process(delta):
	# Get input for horizontal movement
	var direction_x = Input.get_axis("move_left", "move_right")
	var touch_direction_x = 0.0
	
	if Input.is_action_pressed("touch_move_left"):
		touch_direction_x -= 1.0
	if Input.is_action_pressed("touch_move_right"):
		touch_direction_x += 1.0
		
	if direction_x != 0:
		facing_direction.x = direction_x
	elif touch_direction_x != 0: # Prioritize keyboard if both are pressed, or combine
		facing_direction.x = touch_direction_x

	# Combine inputs (or prioritize touch if both are active)
	if touch_direction_x != 0:
		velocity.x = touch_direction_x * SPEED
	else:
		velocity.x = direction_x * SPEED
	
	velocity.y = 0 # No gravity or jumping yet
	
	# Move the character
	move_and_slide()

func _unhandled_input(event):
	# Handle keyboard shoot
	if event.is_action_pressed("shoot"):
		_shoot()
	
	# Handle touch shoot (TouchScreenButton's action also comes here as an InputEventAction)
	if event.is_action_pressed("touch_shoot"):
		_shoot()

func _shoot():
	var bullet_instance = BULLET_SCENE.instantiate()
	bullet_instance.direction = facing_direction
	bullet_instance.global_position = global_position 
	get_tree().root.add_child(bullet_instance)

func take_damage(amount):
	health -= amount
	health_changed.emit(health) # Emit health changed signal
	print("Player health: ", health)
	if health <= 0:
		print("Player Died!")
		died.emit() # Emit died signal
		queue_free()
