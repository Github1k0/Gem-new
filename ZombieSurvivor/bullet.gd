extends Area2D

const SPEED = 500.0
var direction = Vector2.RIGHT # Default, will be set by player
var lifetime = 2.0 # Seconds

func _ready():
	# collision_layer and collision_mask are set in Bullet.tscn
	# Connect the 'body_entered' signal to the '_on_body_entered' method.
	connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	global_position += direction * SPEED * delta
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("zombies"):
		if body.has_method("take_damage"):
			body.take_damage(10) # Deal 10 damage
		queue_free() # Bullet disappears on hit
	# Note: If the bullet should also disappear on hitting other things, 
	# you might move queue_free() outside the if, or add more conditions.
	# For now, it only disappears if it hits something in the "zombies" group.
