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
	
	if direction_x != 0:
		facing_direction.x = direction_x
		# facing_direction.y = 0 # Not strictly needed if player only moves horizontally

	# Set velocity
	velocity.x = direction_x * SPEED
	velocity.y = 0 # No gravity or jumping yet
	
	# Move the character
	move_and_slide()

func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
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
