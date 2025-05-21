extends CharacterBody2D

const SPEED = 75.0
@export var health = 30
var player = null

func _ready():
	add_to_group("zombies")
	# collision_layer and collision_mask are set in Zombie.tscn
	player = get_tree().get_first_node_in_group("player")
	if player == null:
		print("Player not found in group 'player'. Zombie will be idle.")

func _physics_process(delta):
	if player != null and is_instance_valid(player): # Check if player instance is still valid
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * SPEED
	else:
		velocity = Vector2.ZERO 
		# Try to find player again if it was null or became invalid
		if not is_instance_valid(player):
			player = get_tree().get_first_node_in_group("player")
			if player == null:
				print("Player still not found. Zombie remains idle.")

	move_and_slide()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision and collision.get_collider() and collision.get_collider().is_in_group("player"):
			# Check if the collider has the take_damage method
			if collision.get_collider().has_method("take_damage"):
				collision.get_collider().take_damage(10) # Deal 10 damage on contact
			# Optional: Add a cooldown here if needed


func take_damage(amount):
	health -= amount
	if health <= 0:
		queue_free()
