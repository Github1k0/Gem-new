extends Area2D

signal player_won

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))
	# Collision layer/mask will be set in the scene file or next step

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_won.emit()
		print("Player reached the WIN AREA! YOU WIN!")
		# Future enhancements:
		# get_tree().paused = true
		# get_tree().change_scene_to_file("res://win_screen.tscn")
