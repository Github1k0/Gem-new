extends CanvasLayer

@onready var health_label = $HealthLabel
@onready var message_label = $MessageLabel

func _ready():
	# Connect to Player signals
	var player = get_tree().get_first_node_in_group("player")
	if player:
		if player.has_signal("health_changed"): # Check if the signal exists
			player.health_changed.connect(_on_player_health_changed)
		else:
			print("UI: Player does not have health_changed signal.")
			
		if player.has_signal("died"): # Check if the signal exists
			player.died.connect(_on_player_died)
		else:
			print("UI: Player does not have died signal.")
	else:
		print("UI: Player node not found in group 'player'!")
		# Optionally set default health text if player is not immediately available
		health_label.text = "Health: N/A"

	# Connect to WinArea signals
	# This search might be slow if the scene tree is very large.
	# A more robust way is to have the Level scene get a reference to WinArea and UI,
	# and then connect signals, or for Level to re-emit the player_won signal.
	# For now, find_child is used as per subtask description.
	var win_area = get_tree().get_root().find_child("WinArea", true, false) # Recursive search
	if win_area:
		if win_area.has_signal("player_won"): # Check if the signal exists
			win_area.player_won.connect(_on_player_won)
		else:
			print("UI: WinArea does not have player_won signal.")
	else:
		print("UI: WinArea node not found!")

func _on_player_health_changed(current_health):
	health_label.text = "Health: " + str(current_health)

func _on_player_died():
	message_label.text = "GAME OVER!"
	message_label.visible = true

func _on_player_won():
	message_label.text = "YOU WIN!"
	message_label.visible = true
